import 'dart:async';
import 'wallet_models.dart';

abstract class WalletRepository {
  /// Stream of reactive wallet state updates.
  Stream<WalletState> watchState();

  /// Current synchronous snapshot of the wallet state.
  WalletState get currentState;

  /// Checks whether an MWA-compatible wallet is installed or supported.
  Future<bool> checkMwaAvailability();

  /// Connects to a compatible mobile wallet via MWA and requests account authorization.
  Future<WalletAccount> connect();

  /// Disconnects the active wallet session and clears persisted public credentials.
  Future<void> disconnect();

  /// Refreshes the on-chain SOL balance via RPC for the connected account.
  Future<int> refreshBalance();

  /// Requests wallet signature for a base64 encoded transaction wire payload.
  Future<String> signTransaction(String unsignedBase64);

  /// Requests Devnet test SOL airdrop.
  Future<String> requestAirdrop({int lamports = 1000000000});

  /// Releases resources.
  void dispose();
}

