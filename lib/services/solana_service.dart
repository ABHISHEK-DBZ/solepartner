import 'dart:async';
import 'dart:convert';

import 'package:solana/dto.dart'
    show
        BalanceResult,
        Encoding,
        LatestBlockhashResult,
        ParsedInstructionSystem,
        ParsedSystemTransferInstruction,
        ParsedTransaction,
        SignatureStatus,
        SignatureStatusesResult,
        TransactionDetails;
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:solana_wallet_adapter/solana_wallet_adapter.dart';

class SolanaException implements Exception {
  SolanaException(this.message, {this.isCancellation = false});
  final String message;
  final bool isCancellation;
  @override
  String toString() => message;
}

enum TxState { confirmed, failed, unknown }

class TxOutcome {
  const TxOutcome(this.state, {this.error, this.signature});

  final TxState state;
  final String? error;
  final String? signature;
}

class PreparedTransfer {
  const PreparedTransfer({
    required this.unsignedBase64,
    required this.blockhash,
    required this.lastValidBlockHeight,
  });

  final String unsignedBase64;
  final String blockhash;
  final int lastValidBlockHeight;
}

/// Talks to the Devnet RPC and to an installed Solana mobile wallet.
///
/// Private keys never enter this app: signing always happens inside the wallet
/// through the Mobile Wallet Adapter protocol.
class SolanaService {
  SolanaService({String? rpcUrl})
      : _client = RpcClient(rpcUrl ?? devnetRpcUrl, timeout: const Duration(seconds: 30));

  static const String devnetRpcUrl = 'https://api.devnet.solana.com';
  static const String network = 'devnet';
  static const String _explorerBase = 'https://explorer.solana.com';

  final RpcClient _client;
  SolanaWalletAdapter? _adapter;
  String? _connectedAddress;

  SolanaWalletAdapter get _wallet {
    return _adapter ??= SolanaWalletAdapter(
      const AppIdentity(name: 'KhataCopilot'),
      cluster: Cluster.devnet,
      timeLimit: const Duration(minutes: 3),
    );
  }

  /// Loads any saved wallet authorization. Call once before the UI starts.
  static Future<void> initializeWalletAdapter() async {
    await SolanaWalletAdapter.initialize();
  }

  bool get isConnected => _wallet.isAuthorized;

  String? get connectedAddress {
    if (_connectedAddress != null) return _connectedAddress;
    final Account? account = _wallet.connectedAccount;
    return account?.toBase58();
  }

  Future<String> connect() async {
    try {
      // A stored authorizeResult makes the adapter relaunch the previous
      // wallet's base URI even for a fresh authorize. Drop it so the user can
      // pick any installed wallet (and so an uninstalled wallet cannot win).
      if (_wallet.authorizeResult != null) {
        await _wallet.clear();
      }
      final AuthorizeResult result = await _wallet.authorize();
      if (result.accounts.isEmpty) {
        throw SolanaException('The wallet did not share an account.');
      }
      final String address = result.accounts.first.toBase58();
      _connectedAddress = address;
      return address;
    } on SolanaWalletAdapterException catch (error) {
      if (error.code == SolanaWalletAdapterExceptionCode.cancelled) {
        throw SolanaException('Wallet connection was cancelled.',
            isCancellation: true);
      }
      if (error.code == SolanaWalletAdapterExceptionCode.walletNotFound) {
        throw SolanaException(
            'No Mobile Wallet Adapter wallet was found. Install Phantom or '
            'Solflare and set it to Devnet.');
      }
      throw SolanaException(
          'Could not connect the wallet (${error.code}): ${error.message}');
    } on SolanaWalletAdapterProtocolException catch (error) {
      // Phantom returns -1 when its active network is not Devnet. Solflare
      // switches automatically; Phantom does not.
      if (error.code ==
          SolanaWalletAdapterProtocolExceptionCode.authorizationFailed) {
        throw SolanaException(
            'Phantom rejected the authorization. In Phantom open Settings → '
            'Developer Settings → Change Network → Devnet, then try again.');
      }
      if (error.code ==
          SolanaWalletAdapterProtocolExceptionCode.clusterNotSupported) {
        throw SolanaException('The wallet does not support the Devnet cluster.');
      }
      throw SolanaException(
          'Could not connect the wallet (${error.code}): ${error.message}');
    } catch (error) {
      throw SolanaException('Could not connect the wallet: $error');
    }
  }

  Future<void> disconnect() async {
    try {
      await _wallet.deauthorize();
    } finally {
      _connectedAddress = null;
    }
  }

  Future<int> getBalanceLamports(String address) async {
    try {
      final BalanceResult result = await _client.getBalance(address);
      return result.value;
    } catch (error) {
      throw SolanaException('Could not read the Devnet balance: $error');
    }
  }

  Future<String> requestAirdrop(String address, {int lamports = 1000000000}) async {
    try {
      final String sig = await _client.requestAirdrop(
        address,
        lamports,
        commitment: Commitment.confirmed,
      );
      await pollConfirmation(sig);
      return sig;
    } catch (error) {
      throw SolanaException('Could not request airdrop: $error');
    }
  }

  Future<PreparedTransfer> prepareTransfer({
    required String fromAddress,
    required String toAddress,
    required int lamports,
  }) async {
    if (lamports <= 0) {
      throw SolanaException('Amount must be greater than zero.');
    }
    try {
      final Ed25519HDPublicKey from = Ed25519HDPublicKey.fromBase58(fromAddress);
      final Ed25519HDPublicKey to = Ed25519HDPublicKey.fromBase58(toAddress);
      final LatestBlockhashResult blockhash =
          await _client.getLatestBlockhash(commitment: Commitment.confirmed);

      final Message message = Message(instructions: <Instruction>[
        SystemInstruction.transfer(
          fundingAccount: from,
          recipientAccount: to,
          lamports: lamports,
        ),
      ]);
      final CompiledMessage compiled = message.compile(
        recentBlockhash: blockhash.value.blockhash,
        feePayer: from,
      );
      final SignedTx unsigned = SignedTx(
        signatures: const <Signature>[],
        compiledMessage: compiled,
      );

      return PreparedTransfer(
        unsignedBase64: unsigned.encode(),
        blockhash: blockhash.value.blockhash,
        lastValidBlockHeight: blockhash.value.lastValidBlockHeight,
      );
    } on SolanaException {
      rethrow;
    } catch (error) {
      throw SolanaException('Could not build the transaction: $error');
    }
  }

  /// Asks the wallet to sign. Rejection surfaces as a cancellation.
  Future<String> signTransaction(String unsignedBase64) async {
    try {
      final SignTransactionsResult result =
          await _wallet.signTransactions(<String>[unsignedBase64]);
      if (result.signedPayloads.isEmpty) {
        throw SolanaException('The wallet returned no signed transaction.');
      }
      return result.signedPayloads.first;
    } on SolanaWalletAdapterException catch (error) {
      if (error.code == SolanaWalletAdapterExceptionCode.cancelled) {
        throw SolanaException('Payment was rejected in the wallet.',
            isCancellation: true);
      }
      throw SolanaException(
          'Wallet signing failed (${error.code}): ${error.message}');
    } catch (error) {
      throw SolanaException('Wallet signing failed: $error');
    }
  }

  /// Decodes and verifies the signed wire transaction prior to cluster broadcast.
  /// Guarantees that the wallet did not alter the intended source or recipient account.
  void verifySignedWireTransaction({
    required String signedBase64,
    required String fromAddress,
    required String toAddress,
  }) {
    try {
      final List<int> bytes = base64Decode(signedBase64);
      final SignedTx decoded = SignedTx.fromBytes(bytes);
      if (decoded.signatures.isEmpty) {
        throw SolanaException('Signed payload contains no cryptographic signatures.');
      }
      final List<String> accountKeys = decoded.compiledMessage.accountKeys
          .map((Ed25519HDPublicKey a) => a.toBase58())
          .toList();
      if (!accountKeys.contains(fromAddress)) {
        throw SolanaException('Signed transaction source address does not match.');
      }
      if (!accountKeys.contains(toAddress)) {
        throw SolanaException('Signed transaction destination address does not match.');
      }
    } on SolanaException {
      rethrow;
    } catch (e) {
      throw SolanaException(
          'Could not decode or verify the signed transaction wire payload: $e');
    }
  }

  Future<String> submitSignedTransaction(String signedBase64) async {
    try {
      return await _client.sendTransaction(
        signedBase64,
        preflightCommitment: Commitment.confirmed,
      );
    } catch (error) {
      throw SolanaException('Could not submit the transaction: $error');
    }
  }

  /// Polls the cluster until the signature is confirmed, fails, or times out.
  Future<TxOutcome> pollConfirmation(
    String signature, {
    Duration timeout = const Duration(seconds: 90),
  }) async {
    final DateTime deadline = DateTime.now().add(timeout);
    Object? lastError;
    while (DateTime.now().isBefore(deadline)) {
      try {
        final SignatureStatusesResult result = await _client
            .getSignatureStatuses(<String>[signature], searchTransactionHistory: true);
        if (result.value.isNotEmpty) {
          final SignatureStatus? status = result.value.first;
          if (status != null) {
            if (status.err != null) {
              return TxOutcome(TxState.failed, signature: signature, error: '${status.err}');
            }
            if (status.confirmationStatus == Commitment.confirmed ||
                status.confirmationStatus == Commitment.finalized) {
              return TxOutcome(TxState.confirmed, signature: signature);
            }
          }
        }
      } catch (error) {
        lastError = error;
      }
      await Future<void>.delayed(const Duration(seconds: 2));
    }
    return TxOutcome(
      TxState.unknown,
      signature: signature,
      error: lastError == null
          ? 'Confirmation timed out. Check the explorer before retrying.'
          : 'Confirmation could not be checked: $lastError',
    );
  }

  /// Confirms that the on-chain transaction really pays [lamports] from
  /// [fromAddress] to [toAddress]. A successful status alone is not enough:
  /// the wallet could have signed something else.
  Future<void> verifyTransfer({
    required String signature,
    required String fromAddress,
    required String toAddress,
    required int lamports,
  }) async {
    final TransactionDetails? details;
    try {
      details = await _client.getTransaction(
        signature,
        encoding: Encoding.jsonParsed,
        commitment: Commitment.confirmed,
      );
    } catch (error) {
      throw SolanaException('Could not verify the transaction: $error');
    }
    if (details == null) {
      throw SolanaException('The cluster does not know this transaction.');
    }
    if (details.meta?.err != null) {
      throw SolanaException(
          'The transaction failed on-chain: ${details.meta!.err}');
    }
    final TransactionDetails tx = details;
    if (tx.transaction is! ParsedTransaction) {
      throw SolanaException('The transaction could not be decoded.');
    }
    final ParsedTransaction parsed = tx.transaction as ParsedTransaction;
    for (final instruction in parsed.message.instructions) {
      if (instruction is ParsedInstructionSystem &&
          instruction.parsed is ParsedSystemTransferInstruction) {
        final ParsedSystemTransferInstruction transfer =
            instruction.parsed as ParsedSystemTransferInstruction;
        if (transfer.info.source == fromAddress &&
            transfer.info.destination == toAddress &&
            transfer.info.lamports == lamports) {
          return;
        }
      }
    }
    throw SolanaException(
        'The on-chain transaction does not pay the expected amount to the '
        'expected address.');
  }

  String explorerUrl(String signature) =>
      '$_explorerBase/tx/$signature?cluster=$network';
}
