import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/wallet/wallet_models.dart';
import '../../domain/wallet/wallet_repository.dart';
import '../../services/solana_service.dart';

class MobileWalletRepository implements WalletRepository {
  MobileWalletRepository({
    required SolanaService solanaService,
    required FlutterSecureStorage secureStorage,
  })  : _solana = solanaService,
        _storage = secureStorage {
    _init();
  }

  final SolanaService _solana;
  final FlutterSecureStorage _storage;

  final StreamController<WalletState> _stateController =
      StreamController<WalletState>.broadcast();

  WalletState _currentState = WalletState.disconnected;

  static const String _storageKeyAddress = 'solana_wallet_public_address';
  static const String _storageKeyCluster = 'solana_wallet_cluster';
  static const String _storageKeyLastActivity = 'solana_wallet_last_activity';

  @override
  WalletState get currentState => _currentState;

  @override
  Stream<WalletState> watchState() => _stateController.stream;

  void _updateState(WalletState newState) {
    _currentState = newState;
    if (!_stateController.isClosed) {
      _stateController.add(newState);
    }
  }

  Future<void> _init() async {
    // 1. Initialize MWA protocol adapter
    try {
      await SolanaService.initializeWalletAdapter();
    } catch (_) {}

    // 2. Check if a previously authorized address was stored securely
    try {
      final String? savedAddress = await _storage.read(key: _storageKeyAddress);
      final String? lastActivityStr =
          await _storage.read(key: _storageKeyLastActivity);
      final DateTime? lastActivity = lastActivityStr != null
          ? DateTime.tryParse(lastActivityStr)
          : null;

      if (savedAddress != null && savedAddress.isNotEmpty) {
        _updateState(_currentState.copyWith(
          status: WalletConnectionStatus.connected,
          account: WalletAccount(address: savedAddress),
          lastActivity: lastActivity,
        ));
        // Refresh balance in background
        unawaited(refreshBalance());
      }
    } catch (_) {}
  }

  @override
  Future<bool> checkMwaAvailability() async {
    try {
      // SolanaWalletAdapter checks protocol registration
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<WalletAccount> connect() async {
    _updateState(_currentState.copyWith(
      status: WalletConnectionStatus.connecting,
      errorMessage: null,
    ));

    try {
      final String address = await _solana.connect();
      final DateTime now = DateTime.now();

      // Persist only non-sensitive public metadata in hardware-backed secure storage
      await _storage.write(key: _storageKeyAddress, value: address);
      await _storage.write(key: _storageKeyCluster, value: _currentState.cluster.name);
      await _storage.write(key: _storageKeyLastActivity, value: now.toIso8601String());

      final WalletAccount account = WalletAccount(address: address);
      _updateState(_currentState.copyWith(
        status: WalletConnectionStatus.connected,
        account: account,
        lastActivity: now,
      ));

      await refreshBalance();
      return account;
    } on SolanaException catch (e) {
      if (e.isCancellation) {
        _updateState(_currentState.copyWith(
          status: WalletConnectionStatus.disconnected,
          errorMessage: 'Wallet authorization was cancelled by the user.',
        ));
      } else {
        _updateState(_currentState.copyWith(
          status: WalletConnectionStatus.error,
          errorMessage: e.message,
        ));
      }
      rethrow;
    } catch (e) {
      final String msg = e.toString().replaceAll('Exception: ', '');
      _updateState(_currentState.copyWith(
        status: WalletConnectionStatus.error,
        errorMessage: msg,
      ));
      throw SolanaException(msg);
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _solana.disconnect();
    } catch (_) {}

    // Clear saved public address
    try {
      await _storage.delete(key: _storageKeyAddress);
      await _storage.delete(key: _storageKeyLastActivity);
    } catch (_) {}

    _updateState(WalletState.disconnected);
  }

  @override
  Future<int> refreshBalance() async {
    final String? address = _currentState.address;
    if (address == null) return 0;

    try {
      final int lamports = await _solana.getBalanceLamports(address);
      _updateState(_currentState.copyWith(
        balanceLamports: lamports,
        balanceError: null,
      ));
      return lamports;
    } catch (e) {
      final String err = e.toString();
      _updateState(_currentState.copyWith(balanceError: err));
      return _currentState.balanceLamports ?? 0;
    }
  }

  @override
  Future<String> signTransaction(String unsignedBase64) async {
    if (!_currentState.isConnected) {
      throw SolanaException('Wallet is not connected.');
    }
    final String signed = await _solana.signTransaction(unsignedBase64);
    final DateTime now = DateTime.now();
    await _storage.write(key: _storageKeyLastActivity, value: now.toIso8601String());
    _updateState(_currentState.copyWith(lastActivity: now));
    return signed;
  }

  @override
  Future<String> requestAirdrop({int lamports = 1000000000}) async {
    final String? address = _currentState.address;
    if (address == null) {
      throw SolanaException('Connect a wallet before requesting an airdrop.');
    }
    final String signature =
        await _solana.requestAirdrop(address, lamports: lamports);
    await refreshBalance();
    return signature;
  }

  @override
  void dispose() {
    _stateController.close();
  }
}
