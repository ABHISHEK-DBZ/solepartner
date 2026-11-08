import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:khatacopilot/services/solana_service.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

void main() {
  test('SignedTx encode and decode test', () async {
    final Ed25519HDPublicKey from = Ed25519HDPublicKey.fromBase58('11111111111111111111111111111111');
    final Ed25519HDPublicKey to = Ed25519HDPublicKey.fromBase58('TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA');
    final Message message = Message(instructions: [
      SystemInstruction.transfer(fundingAccount: from, recipientAccount: to, lamports: 500000)
    ]);
    final CompiledMessage compiled = message.compile(
      recentBlockhash: '11111111111111111111111111111111',
      feePayer: from,
    );
    final SignedTx unsigned = SignedTx(
      signatures: const <Signature>[],
      compiledMessage: compiled,
    );
    final String base64Str = unsigned.encode();
    final SignedTx decoded = SignedTx.fromBytes(base64Decode(base64Str));
    expect(decoded.compiledMessage.accountKeys.isNotEmpty, isTrue);
    final List<String> accounts = decoded.compiledMessage.accountKeys.map((a) => a.toBase58()).toList();
    expect(accounts.contains(to.toBase58()), isTrue);
  });

  test('verifySignedWireTransaction verifies recipient and source addresses', () async {
    final SolanaService solana = SolanaService();
    final Ed25519HDPublicKey from = Ed25519HDPublicKey.fromBase58('11111111111111111111111111111111');
    final Ed25519HDPublicKey to = Ed25519HDPublicKey.fromBase58('TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA');
    final Message message = Message(instructions: [
      SystemInstruction.transfer(fundingAccount: from, recipientAccount: to, lamports: 500000)
    ]);
    final CompiledMessage compiled = message.compile(
      recentBlockhash: '11111111111111111111111111111111',
      feePayer: from,
    );
    final SignedTx signed = SignedTx(
      signatures: <Signature>[
        Signature(List<int>.filled(64, 1), publicKey: from),
      ],
      compiledMessage: compiled,
    );
    final String signedBase64 = signed.encode();

    // Valid check: should succeed without exception
    expect(
      () => solana.verifySignedWireTransaction(
        signedBase64: signedBase64,
        fromAddress: from.toBase58(),
        toAddress: to.toBase58(),
      ),
      returnsNormally,
    );

    // Tampered destination check: should throw SolanaException
    expect(
      () => solana.verifySignedWireTransaction(
        signedBase64: signedBase64,
        fromAddress: from.toBase58(),
        toAddress: '4Nd1mBQtrMKBCzYviUR2xK3tKj9S8G2Fv4674o7K8341',
      ),
      throwsA(isA<SolanaException>()),
    );
  });
}
