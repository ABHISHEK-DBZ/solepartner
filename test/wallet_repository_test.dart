import 'package:flutter_test/flutter_test.dart';
import 'package:khatacopilot/domain/wallet/wallet_models.dart';
import 'package:khatacopilot/domain/wallet/wallet_repository.dart';

class FakeWalletRepository implements WalletRepository {
  WalletState _state = WalletState.disconnected;

  @override
  WalletState get currentState => _state;

  @override
  Stream<WalletState> watchState() => Stream.value(_state);

  @override
  Future<bool> checkMwaAvailability() async => true;

  @override
  Future<WalletAccount> connect() async {
    final WalletAccount account = const WalletAccount(
      address: 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA',
    );
    _state = _state.copyWith(
      status: WalletConnectionStatus.connected,
      account: account,
      balanceLamports: 12540000000,
      lastActivity: DateTime(2026, 1, 1),
    );
    return account;
  }

  @override
  Future<void> disconnect() async {
    _state = WalletState.disconnected;
  }

  @override
  Future<int> refreshBalance() async {
    return _state.balanceLamports ?? 0;
  }

  @override
  Future<String> signTransaction(String unsignedBase64) async {
    if (!_state.isConnected) throw Exception('Wallet not connected');
    return 'signed_base64_payload';
  }

  @override
  Future<String> requestAirdrop({int lamports = 1000000000}) async {
    return 'fake_sig';
  }

  @override
  void dispose() {}
}

void main() {
  group('Wallet Repository & State Tests', () {
    test('initial state is disconnected on Devnet', () {
      final FakeWalletRepository repo = FakeWalletRepository();
      expect(repo.currentState.status, WalletConnectionStatus.disconnected);
      expect(repo.currentState.cluster, SolanaCluster.devnet);
      expect(repo.currentState.isConnected, isFalse);
      expect(repo.currentState.address, isNull);
    });

    test('connecting updates state to connected with public address and balance', () async {
      final FakeWalletRepository repo = FakeWalletRepository();
      final WalletAccount account = await repo.connect();

      expect(account.address, 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA');
      expect(account.truncatedAddress, 'Toke...Q5DA');
      expect(repo.currentState.isConnected, isTrue);
      expect(repo.currentState.balanceLamports, 12540000000);
      expect(repo.currentState.lastActivity, isNotNull);
    });

    test('disconnecting resets state to disconnected and clears account', () async {
      final FakeWalletRepository repo = FakeWalletRepository();
      await repo.connect();
      expect(repo.currentState.isConnected, isTrue);

      await repo.disconnect();
      expect(repo.currentState.isConnected, isFalse);
      expect(repo.currentState.address, isNull);
      expect(repo.currentState.balanceLamports, isNull);
    });

    test('SolanaCluster enum distinguishes Devnet and Mainnet', () {
      expect(SolanaCluster.devnet.isLiveMoney, isFalse);
      expect(SolanaCluster.testnet.isLiveMoney, isFalse);
      expect(SolanaCluster.mainnetBeta.isLiveMoney, isTrue);
      expect(SolanaCluster.devnet.displayName, contains('Test'));
      expect(SolanaCluster.mainnetBeta.displayName, contains('Live'));
    });
  });
}

