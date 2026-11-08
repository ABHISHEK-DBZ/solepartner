import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';

Future<void> showAddTransactionSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context) => const AddTransactionSheet(),
  );
}

class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  ConsumerState<AddTransactionSheet> createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _note = TextEditingController();
  TransactionKind _kind = TransactionKind.sale;
  PaymentMethod _method = PaymentMethod.cash;
  int? _customerId;
  bool _busy = false;

  static const List<(TransactionKind, String)> _kinds = <(TransactionKind, String)>[
    (TransactionKind.sale, 'Sale'),
    (TransactionKind.expense, 'Expense'),
    (TransactionKind.income, 'Income'),
    (TransactionKind.cashReceived, 'Cash in'),
    (TransactionKind.creditGiven, 'Credit given'),
    (TransactionKind.creditRepayment, 'Repayment'),
  ];

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  bool get _needsCustomer =>
      _kind == TransactionKind.creditGiven ||
      _kind == TransactionKind.creditRepayment;

  Future<void> _save() async {
    final int? paise = Money.parseRupeeField(_amount.text);
    if (paise == null) {
      showError(context, 'Enter an amount greater than zero.');
      return;
    }
    if (_needsCustomer && _customerId == null) {
      showError(context, 'Choose a customer for this entry.');
      return;
    }
    if (_kind == TransactionKind.creditRepayment) {
      final List<CustomerView> customers =
          ref.read(allCustomersProvider).valueOrNull ?? const <CustomerView>[];
      CustomerView? customer;
      for (final CustomerView c in customers) {
        if (c.id == _customerId) {
          customer = c;
          break;
        }
      }
      if (customer != null && paise > customer.outstandingPaise) {
        showError(
          context,
          'Repayment cannot exceed ${Money.format(customer.outstandingPaise)} '
          'outstanding.',
        );
        return;
      }
    }
    setState(() => _busy = true);
    try {
      await ref.read(ledgerRepositoryProvider).recordEntry(
            kind: _kind,
            amountPaise: paise,
            method: _kind == TransactionKind.creditGiven
                ? PaymentMethod.credit
                : _method,
            customerId: _customerId,
            note: _note.text,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      showMessage(context, '${_kind.label} of ${Money.format(paise)} saved.');
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<CustomerView>> customers =
        ref.watch(allCustomersProvider);
    final List<CustomerView> list = customers.valueOrNull ?? <CustomerView>[];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('New entry', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              'Every entry creates an audit trail. Nothing is deleted.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _kinds
                  .map(((TransactionKind, String) option) => ChoiceChip(
                        label: Text(option.$2),
                        selected: _kind == option.$1,
                        onSelected: (_) => setState(() {
                          _kind = option.$1;
                          if (_kind == TransactionKind.creditGiven) {
                            _method = PaymentMethod.credit;
                          } else if (_method == PaymentMethod.credit) {
                            _method = PaymentMethod.cash;
                          }
                        }),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 18),
            AmountField(controller: _amount, autofocus: true),
            LabeledField(
              label: _needsCustomer ? 'Customer' : 'Customer (optional)',
              child: DropdownButtonFormField<int?>(
                initialValue: _customerId,
                items: <DropdownMenuItem<int?>>[
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('No customer'),
                  ),
                  ...list.map((CustomerView c) => DropdownMenuItem<int?>(
                        value: c.id,
                        child: Text(
                          c.outstandingPaise > 0
                              ? '${c.name} · owes ${Money.format(c.outstandingPaise)}'
                              : c.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                ],
                onChanged: (int? value) => setState(() => _customerId = value),
              ),
            ),
            if (_kind != TransactionKind.creditGiven) ...<Widget>[
              LabeledField(
                label: 'Payment method',
                child: Wrap(
                  spacing: 8,
                  children: <PaymentMethod>[
                    PaymentMethod.cash,
                    PaymentMethod.upi,
                    PaymentMethod.bank,
                  ]
                      .map((PaymentMethod method) => ChoiceChip(
                            label: Text(method.name.toUpperCase()),
                            selected: _method == method,
                            onSelected: (_) => setState(() => _method = method),
                          ))
                      .toList(),
                ),
              ),
            ],
            LabeledField(
              label: 'Note (optional)',
              child: TextField(
                controller: _note,
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'What was this for?',
                ),
              ),
            ),
            const SizedBox(height: 4),
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
                  : const Text('Save entry'),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                _kind == TransactionKind.creditGiven
                    ? 'Credit increases what the customer owes you.'
                    : 'Cash and credit effects are computed once, on the server of record: your phone.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: AppColors.inkFaint),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
