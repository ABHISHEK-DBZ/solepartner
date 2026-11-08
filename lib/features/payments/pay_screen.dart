import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../data/db/app_database.dart';
import '../../domain/models.dart';
import '../../domain/rules/voice_parser.dart';
import '../../services/payment_service.dart';
import '../../services/solana_service.dart';
import '../dashboard/dashboard_providers.dart';

class PayScreen extends ConsumerStatefulWidget {
  const PayScreen({super.key});

  @override
  ConsumerState<PayScreen> createState() => _PayScreenState();
}

enum _PaymentStep { awaitingApproval, signing, submitted, confirmed, failed }

class _PayScreenState extends ConsumerState<PayScreen> {
  final TextEditingController _input = TextEditingController();

  String _userCommand = '';
  String _recipientName = '';
  String _recipientAddress = '';
  int _amountPaise = 0;
  int _amountLamports = 0;
  bool _hasPayment = false;
  bool _listening = false;
  bool _seededFromCommand = false;

  _PaymentStep _step = _PaymentStep.awaitingApproval;
  String? _txSignature;
  String? _errorMessage;

  String get _amountLabel => _amountLamports > 0
      ? '${Money.formatSol(_amountLamports)} SOL'
      : Money.format(_amountPaise);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seededFromCommand) return;
    _seededFromCommand = true;
    final Object? extra = GoRouterState.of(context).extra;
    if (extra is! ParsedCommand) return;
    _hasPayment = true;
    _userCommand = extra.rawText;
    _recipientName = extra.payeeName ?? extra.customerName ?? _recipientName;
    if (extra.payeeAddress != null && extra.payeeAddress!.isNotEmpty) {
      _recipientAddress = extra.payeeAddress!;
    }
    if (extra.amountPaise != null) _amountPaise = extra.amountPaise!;
    if (extra.amountLamports != null) {
      _amountLamports = extra.amountLamports!;
    } else {
      _amountLamports = 0;
      _errorMessage =
          'Tell me the amount in SOL for an on-chain payment.';
    }
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _approveAndPay() async {
    HapticFeedback.mediumImpact();
    if (_recipientAddress.trim().isEmpty) {
      setState(() {
        _step = _PaymentStep.failed;
        _errorMessage = 'Name a saved recipient before paying.';
      });
      return;
    }
    if (_amountLamports <= 0) {
      setState(() {
        _step = _PaymentStep.failed;
        _errorMessage =
            'Tell me the amount in SOL for an on-chain payment.';
      });
      return;
    }
    final WalletSnapshot wallet = ref.read(walletProvider);

    // If wallet not connected, connect first
    if (!wallet.connected) {
      try {
        await ref.read(walletProvider.notifier).connect();
      } catch (error) {
        setState(() {
          _step = _PaymentStep.failed;
          _errorMessage = error.toString().replaceAll('Exception: ', '');
        });
        return;
      }
    }

    final WalletSnapshot activeWallet = ref.read(walletProvider);
    final String? fromAddress = activeWallet.address;
    if (fromAddress == null) {
      setState(() {
        _step = _PaymentStep.failed;
        _errorMessage = 'Connect a Solana wallet before paying.';
      });
      return;
    }

    setState(() {
      _step = _PaymentStep.signing;
      _errorMessage = null;
    });

    try {
      final PaymentService service = ref.read(paymentServiceProvider);
      final List<Payee> payees =
          await ref.read(paymentRepositoryProvider).loadPayees();
      Payee? savedPayee;
      for (final Payee payee in payees) {
        if (payee.walletAddress == _recipientAddress) {
          savedPayee = payee;
          break;
        }
      }
      final bool isSavedRecipient = savedPayee != null;

      // 1. Evaluate Spending Policy
      final PolicyEvaluation eval = await service.evaluate(
        amountLamports: _amountLamports,
        recipientAddress: _recipientAddress,
        isSavedRecipient: isSavedRecipient,
        walletBalanceLamports: activeWallet.balanceLamports,
        ownAddress: fromAddress,
      );

      if (!eval.allowed) {
        setState(() {
          _step = _PaymentStep.failed;
          _errorMessage = eval.violations.map((v) => v.message).join('\n');
        });
        return;
      }

      // 2. Propose payment in DB
      final PaymentProposal proposal = await service.propose(
        recipientName: _recipientName,
        recipientAddress: _recipientAddress,
        amountLamports: _amountLamports,
        isSavedRecipient: isSavedRecipient,
        payeeId: savedPayee?.id,
        walletBalanceLamports: activeWallet.balanceLamports,
        ownAddress: fromAddress,
        requestText: _userCommand,
        inrMemoPaise: _amountPaise,
      );

      setState(() => _step = _PaymentStep.submitted);

      // 3. Request wallet sign & submit
      final PaymentResult result = await service.approveAndSend(
        paymentId: proposal.id,
        fromAddress: fromAddress,
      );

      if (result.state == TxState.confirmed) {
        setState(() {
          _step = _PaymentStep.confirmed;
          _txSignature = result.signature;
        });
        ref.invalidate(dashboardEntriesProvider);
      } else {
        setState(() {
          _step = _PaymentStep.failed;
          _errorMessage = result.error ?? 'Payment failed on network.';
        });
      }
    } catch (e) {
      setState(() {
        _step = _PaymentStep.failed;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  void _onSendCommand() {
    final String text = _input.text.trim();
    if (text.isEmpty) return;
    final List<Payee> payees =
        ref.read(allPayeesProvider).valueOrNull ?? const <Payee>[];
    final ParsedCommand parsed = const VoiceParser().parse(
      text,
      payees: payees
          .map((Payee p) => PayeeRef(p.id, p.name, p.walletAddress))
          .toList(),
    );
    setState(() {
      _userCommand = text;
      _hasPayment = true;
      _step = _PaymentStep.awaitingApproval;
      _txSignature = null;
      _errorMessage = null;

      _recipientName =
          parsed.payeeName ?? parsed.customerName ?? _recipientName;
      final String? address = parsed.payeeAddress;
      if (address != null && address.isNotEmpty) _recipientAddress = address;
      if (parsed.amountPaise != null) _amountPaise = parsed.amountPaise!;
      _amountLamports = parsed.amountLamports ?? 0;
      if (_amountLamports <= 0) {
        _errorMessage =
            'Tell me the amount in SOL for an on-chain payment.';
      }
      _input.clear();
    });
  }

  Future<void> _addRecipient() async {
    final TextEditingController name = TextEditingController();
    final TextEditingController address = TextEditingController();
    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Add recipient'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: address,
              decoration: const InputDecoration(
                labelText: 'Solana address',
                hintText: 'Base58 wallet address',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (saved != true) {
      name.dispose();
      address.dispose();
      return;
    }
    try {
      await ref.read(paymentRepositoryProvider).addPayee(
            name: name.text,
            walletAddress: address.text,
          );
      ref.invalidate(allPayeesProvider);
      if (mounted) showMessage(context, 'Recipient saved.');
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      name.dispose();
      address.dispose();
    }
  }

  Future<void> _toggleListen() async {    HapticFeedback.mediumImpact();
    if (_listening) {
      await ref.read(speechServiceProvider).stop();
      setState(() => _listening = false);
      return;
    }
    setState(() => _listening = true);
    try {
      final String transcript =
          await ref.read(speechServiceProvider).listenOnce();
      if (!mounted) return;
      if (transcript.trim().isNotEmpty) {
        _input.text = transcript;
        _onSendCommand();
      }
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _listening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final List<Payee> payees =
        ref.watch(allPayeesProvider).valueOrNull ?? const <Payee>[];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('AI Payment Agent'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Add recipient',
            icon: const Icon(Icons.person_add_alt_1_rounded),
            onPressed: _addRecipient,
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => context.push('/policy'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            // Chat conversation matching Mockup 8
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                children: <Widget>[
                  // User Message Bubble on Right
                  if (_hasPayment)
                    Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(left: 48, bottom: 18),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(6),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        _userCommand,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Bot Message with Robot Avatar on Left
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Icon(Icons.smart_toy_rounded, size: 20, color: colors.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _hasPayment
                                  ? "I've prepared a payment for $_amountLabel to $_recipientName."
                                  : 'Tell me who to pay and how much, for example '
                                      '"Pay 0.01 SOL to Ramesh".',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                            if (!_hasPayment) ...<Widget>[
                              const SizedBox(height: 12),
                              AppCard(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Saved recipients',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...payees.map(
                                      (Payee payee) => ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        title: Text(payee.name),
                                        subtitle: Text(
                                          payee.walletAddress,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        onTap: () {
                                          _input.text =
                                              'Pay 0.01 SOL to ${payee.name}';
                                          _onSendCommand();
                                        },
                                      ),
                                    ),
                                    if (payees.isEmpty)
                                      Text(
                                        'No saved recipients yet.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colors.textSecondary,
                                        ),
                                      ),
                                    const SizedBox(height: 8),
                                    TextButton.icon(
                                      onPressed: _addRecipient,
                                      icon: const Icon(
                                          Icons.person_add_alt_1_rounded,
                                          size: 18),
                                      label: const Text('Add recipient'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (_hasPayment) ...<Widget>[
                            const SizedBox(height: 12),

                            // Structured Payment Card
                            AppCard(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _paymentDetailRow('Amount', _amountLabel, isBold: true),
                                  const Divider(height: 20),
                                  _paymentDetailRow('Recipient', _recipientName),
                                  const Divider(height: 20),
                                  _paymentDetailRow('Method', 'Solana (SOL)'),
                                  const Divider(height: 20),
                                  _paymentDetailRow('Network Fee', '~0.000005 SOL'),
                                  const Divider(height: 20),
                                  _paymentDetailRow('Spending Policy', 'Within Daily Limit', statusColor: colors.success),
                                  const SizedBox(height: 20),

                                  // Status & Action state buttons
                                  if (_step == _PaymentStep.awaitingApproval) ...<Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: FilledButton(
                                            onPressed: _approveAndPay,
                                            style: FilledButton.styleFrom(
                                              backgroundColor: colors.primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                            ),
                                            child: const Text('Approve & Pay'),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              _input.text = _userCommand;
                                              showMessage(context,
                                                  'Edit the command below and send it again.');
                                            },
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                            ),
                                            child: const Text('Modify'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ] else if (_step == _PaymentStep.signing || _step == _PaymentStep.submitted) ...<Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: colors.primary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            _step == _PaymentStep.signing
                                                ? 'Signing with Devnet wallet...'
                                                : 'Submitting to Solana RPC...',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: colors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ] else if (_step == _PaymentStep.confirmed) ...<Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: colors.success.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(color: colors.success.withValues(alpha: 0.3)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.check_circle_rounded, color: colors.success, size: 20),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Payment Verified on Solana',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: colors.success,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Tx: ${_txSignature ?? "Confirmed"}',
                                            style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                                          ),
                                          const SizedBox(height: 8),
                                          GestureDetector(
                                            onTap: () {
                                              launchUrl(Uri.parse(
                                                  'https://explorer.solana.com/tx/$_txSignature?cluster=devnet'));
                                            },
                                            child: Text(
                                              'View on Solana Explorer ↗',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: colors.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ] else if (_step == _PaymentStep.failed) ...<Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: colors.error.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _errorMessage ?? 'Payment not authorized.',
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              color: colors.error,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          TextButton(
                                            onPressed: _approveAndPay,
                                            child: const Text('Try Again'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bottom Command Input Bar matching Mockup 8
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(top: BorderSide(color: colors.border)),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _input,
                      onSubmitted: (_) => _onSendCommand(),
                      decoration: InputDecoration(
                        hintText: 'Type or speak a command...',
                        prefixIcon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: colors.border),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _toggleListen,
                    child: Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[colors.primary, colors.accent],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _listening ? Icons.stop_rounded : Icons.mic_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentDetailRow(String label, String value, {bool isBold = false, Color? statusColor}) {
    final AppThemeColors colors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 17 : 13.5,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: statusColor ?? colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
