import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/models.dart';

class PolicyScreen extends ConsumerStatefulWidget {
  const PolicyScreen({super.key});

  @override
  ConsumerState<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends ConsumerState<PolicyScreen> {
  final TextEditingController _perPayment = TextEditingController();
  final TextEditingController _daily = TextEditingController();
  bool _savedRecipientsOnly = true;
  bool _requireApproval = true;
  bool _loaded = false;
  bool _busy = false;

  @override
  void dispose() {
    _perPayment.dispose();
    _daily.dispose();
    super.dispose();
  }

  void _seed(SpendingPolicy policy) {
    if (_loaded) return;
    _loaded = true;
    _perPayment.text = _solField(policy.maxPerPaymentLamports);
    _daily.text = _solField(policy.dailyLimitLamports);
    _savedRecipientsOnly = policy.savedRecipientsOnly;
    _requireApproval = policy.requireApproval;
  }

  static String _solField(int lamports) {
    final String value = (lamports / Money.lamportsPerSol).toStringAsFixed(4);
    return value
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  Future<void> _save() async {
    final int? perPayment = Money.tryParseSol(_perPayment.text);
    final int? daily = Money.tryParseSol(_daily.text);
    if (perPayment == null || perPayment <= 0) {
      showError(context, 'Per-payment limit must be greater than zero.');
      return;
    }
    if (daily == null || daily < perPayment) {
      showError(context, 'Daily limit must be at least the per-payment limit.');
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(paymentRepositoryProvider).savePolicy(SpendingPolicy(
            maxPerPaymentLamports: perPayment,
            dailyLimitLamports: daily,
            savedRecipientsOnly: _savedRecipientsOnly,
            devnetOnly: true,
            requireApproval: _requireApproval,
          ));
      ref.invalidate(spendingPolicyProvider);
      if (mounted) showMessage(context, 'Spending policy saved.');
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<SpendingPolicy> async = ref.watch(spendingPolicyProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Spending policy')),
      body: async.when(
        loading: () => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (Object error, StackTrace _) => EmptyState(
          icon: Icons.shield_outlined,
          title: 'Could not load policy',
          message: error.toString(),
        ),
        data: (SpendingPolicy policy) {
          _seed(policy);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: <Widget>[
              Text(
                'These limits are enforced by the app before any wallet '
                'signature. The AI cannot change them or bypass them.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  children: <Widget>[
                    LabeledField(
                      label: 'Maximum per payment (SOL)',
                      hint: 'A single payment cannot exceed this.',
                      child: TextField(
                        controller: _perPayment,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                    LabeledField(
                      label: 'Maximum daily spend (SOL)',
                      hint: 'Runs until midnight local time.',
                      child: TextField(
                        controller: _daily,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  children: <Widget>[
                    SwitchListTile(
                      value: _savedRecipientsOnly,
                      onChanged: (bool value) =>
                          setState(() => _savedRecipientsOnly = value),
                      title: const Text('Saved recipients only'),
                      subtitle: const Text(
                        'Block payments to addresses you have not saved.',
                      ),
                    ),
                    SwitchListTile(
                      value: _requireApproval,
                      onChanged: (bool value) =>
                          setState(() => _requireApproval = value),
                      title: const Text('Require owner approval'),
                      subtitle: const Text(
                        'Every payment needs an explicit confirmation.',
                      ),
                    ),
                    const SwitchListTile(
                      value: true,
                      onChanged: null,
                      title: Text('Devnet only'),
                      subtitle: Text(
                        'Hard-locked in this build. Mainnet is out of scope.',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _busy ? null : _save,
                child: _busy
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save policy'),
              ),
              const SizedBox(height: 10),
              Text(
                'Policy checks run locally on every proposal and again right '
                'before signing.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}
