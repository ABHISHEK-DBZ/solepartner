import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';

Future<void> showVoiceSheet(
  BuildContext context, {
  String languageCode = 'en',
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context) => VoiceSheet(languageCode: languageCode),
  );
}

class VoiceSheet extends ConsumerStatefulWidget {
  const VoiceSheet({
    super.key,
    this.languageCode = 'en',
    this.embedded = false,
  });

  final String languageCode;
  final bool embedded;

  @override
  ConsumerState<VoiceSheet> createState() => _VoiceSheetState();
}

class _VoiceSheetState extends ConsumerState<VoiceSheet> {
  final TextEditingController _text = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  AssistantAnswer? _answer;
  ParsedCommand? _command;
  int? _customerId;
  PaymentMethod _method = PaymentMethod.cash;
  bool _listening = false;
  bool _busy = false;

  static const List<String> _examples = <String>[
    'Rahul paid ₹500 cash',
    'Give Suresh ₹200 credit',
    'Record ₹350 electricity expense',
    'Show today’s sales',
  ];

  @override
  void dispose() {
    _text.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _listen() async {
    if (_listening) {
      await ref.read(speechServiceProvider).stop();
      setState(() => _listening = false);
      return;
    }
    setState(() => _listening = true);
    try {
      final String transcript = await ref
          .read(speechServiceProvider)
          .listenOnce(languageCode: widget.languageCode);
      if (!mounted) return;
      if (transcript.trim().isNotEmpty) {
        _text.text = transcript;
        await _ask();
      }
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _listening = false);
    }
  }

  Future<void> _ask() async {
    final String text = _text.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _busy = true;
      _answer = null;
      _command = null;
    });
    try {
      final AssistantAnswer answer = await ref
          .read(assistantServiceProvider)
          .ask(text, languageCode: widget.languageCode);
      if (!mounted) return;
      setState(() {
        _answer = answer;
        _command = answer.command;
        _customerId = answer.command?.customerId;
        _method = answer.command?.method ?? PaymentMethod.cash;
        _amount.text = Money.rupeeFieldValue(answer.command?.amountPaise);
      });
      final bool speakReplies = await ref
          .read(settingsRepositoryProvider)
          .voiceResponsesEnabled();
      if (speakReplies) {
        await ref
            .read(speechServiceProvider)
            .speak(answer.message, languageCode: widget.languageCode);
      }
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    final ParsedCommand? command = _command;
    if (command == null) return;
    final int? paise = Money.parseRupeeField(_amount.text);
    if (paise == null) {
      showError(context, 'Enter a valid amount.');
      return;
    }
    if ((command.intent == AssistantIntent.giveCredit ||
            command.intent == AssistantIntent.recordPaymentReceived) &&
        _customerId == null) {
      showError(context, 'Choose the customer for this entry.');
      return;
    }
    setState(() => _busy = true);
    try {
      final result = await ref
          .read(commandExecutorProvider)
          .execute(
            command.copyWith(
              amountPaise: paise,
              customerId: _customerId,
              method: _method,
            ),
            languageCode: widget.languageCode,
          );
      if (!mounted) return;
      showMessage(context, result.message);
      setState(() {
        _answer = AssistantAnswer(message: result.message);
        _command = null;
        _text.clear();
        _amount.clear();
      });
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _reviewPayment(ParsedCommand command) {
    final GoRouter router = GoRouter.of(context);
    if (!widget.embedded) router.pop();
    router.push('/pay/new', extra: command);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<CustomerView>> customers = ref.watch(
      allCustomersProvider,
    );
    final List<CustomerView> customerList =
        customers.valueOrNull ?? <CustomerView>[];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: AppColors.goldSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.auto_awesome, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Khata Copilot',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'On-device parsing first · cloud only if needed',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (!widget.embedded)
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Center(
              child: GestureDetector(
                onTap: _busy ? null : _listen,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  height: 88,
                  width: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _listening ? AppColors.danger : AppColors.ink,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: (_listening ? AppColors.danger : AppColors.ink)
                            .withValues(alpha: 0.22),
                        blurRadius: _listening ? 26 : 12,
                        spreadRadius: _listening ? 8 : 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    _listening ? Icons.stop_rounded : Icons.mic_none_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                _listening ? 'Listening…' : 'Tap to speak, or type below',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _text,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _ask(),
              decoration: InputDecoration(
                hintText: 'e.g. Priya repaid ₹500',
                suffixIcon: IconButton(
                  onPressed: _busy ? null : _ask,
                  icon: _busy
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.arrow_forward_rounded),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _examples
                  .map(
                    (String example) => ActionChip(
                      label: Text(example),
                      onPressed: () {
                        _text.text = example;
                        _ask();
                      },
                    ),
                  )
                  .toList(),
            ),
            if (_answer != null) ...<Widget>[
              const SizedBox(height: 18),
              AppCard(
                color: AppColors.chip,
                borderColor: AppColors.chip,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        StatusPill(
                          label: _answer!.usedCloud ? 'CLOUD' : 'ON DEVICE',
                          color: _answer!.usedCloud
                              ? AppColors.ink
                              : AppColors.emerald,
                          background: _answer!.usedCloud
                              ? AppColors.goldSoft
                              : AppColors.emeraldSoft,
                        ),
                        if (_answer!.dataPeriod != null) ...<Widget>[
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _answer!.dataPeriod!,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _answer!.message,
                      style: const TextStyle(fontSize: 14, height: 1.45),
                    ),
                    if (_answer!.isEstimate) ...<Widget>[
                      const SizedBox(height: 8),
                      const Text(
                        'Estimate based on recorded entries.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.inkFaint,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            if (_command != null) ...<Widget>[
              const SizedBox(height: 16),
              Text(
                'Confirm before saving',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _command!.actionLabel,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (_command!.confidence < 0.75)
                          const StatusPill(
                            label: 'CHECK',
                            color: AppColors.danger,
                            background: AppColors.dangerSoft,
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (!_command!.isPayment) ...<Widget>[
                      AmountField(controller: _amount, label: 'Amount (₹)'),
                      LabeledField(
                        label:
                            _command!.intent ==
                                    AssistantIntent.recordPaymentReceived ||
                                _command!.intent == AssistantIntent.giveCredit
                            ? 'Customer'
                            : 'Customer (optional)',
                        child: DropdownButtonFormField<int?>(
                          initialValue: _customerId,
                          items: <DropdownMenuItem<int?>>[
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('No customer'),
                            ),
                            ...customerList.map(
                              (CustomerView c) => DropdownMenuItem<int?>(
                                value: c.id,
                                child: Text(
                                  c.outstandingPaise > 0
                                      ? '${c.name} · owes ${Money.format(c.outstandingPaise)}'
                                      : c.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (int? value) =>
                              setState(() => _customerId = value),
                        ),
                      ),
                      if (_command!.intent != AssistantIntent.giveCredit)
                        LabeledField(
                          label: 'Method',
                          child: Wrap(
                            spacing: 8,
                            children:
                                <PaymentMethod>[
                                      PaymentMethod.cash,
                                      PaymentMethod.upi,
                                      PaymentMethod.bank,
                                    ]
                                    .map(
                                      (PaymentMethod method) => ChoiceChip(
                                        label: Text(method.name.toUpperCase()),
                                        selected: _method == method,
                                        onSelected: (_) =>
                                            setState(() => _method = method),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      FilledButton(
                        onPressed: _busy ? null : _save,
                        child: const Text('Save entry'),
                      ),
                    ] else ...<Widget>[
                      const Text(
                        'This creates a payment proposal. Policy checks and '
                        'your wallet signature are still required.',
                        style: TextStyle(fontSize: 12.5, height: 1.4),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => _reviewPayment(_command!),
                        child: const Text('Review payment'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
