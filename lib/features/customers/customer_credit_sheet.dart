import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';

Future<void> showCustomerCreditSheet(
  BuildContext context, {
  required CustomerView customer,
  required bool repayment,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context) => CustomerCreditSheet(
      customer: customer,
      repayment: repayment,
    ),
  );
}

class CustomerCreditSheet extends ConsumerStatefulWidget {
  const CustomerCreditSheet({
    super.key,
    required this.customer,
    required this.repayment,
  });

  final CustomerView customer;
  final bool repayment;

  @override
  ConsumerState<CustomerCreditSheet> createState() =>
      _CustomerCreditSheetState();
}

class _CustomerCreditSheetState extends ConsumerState<CustomerCreditSheet> {
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _note = TextEditingController();
  PaymentMethod _method = PaymentMethod.cash;
  bool _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final int? paise = Money.parseRupeeField(_amount.text);
    if (paise == null) {
      showError(context, 'Enter an amount greater than zero.');
      return;
    }
    if (widget.repayment && paise > widget.customer.outstandingPaise) {
      showError(
        context,
        'Amount is more than the outstanding '
        '${Money.format(widget.customer.outstandingPaise)}.',
      );
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(ledgerRepositoryProvider).recordEntry(
            kind: widget.repayment
                ? TransactionKind.creditRepayment
                : TransactionKind.creditGiven,
            amountPaise: paise,
            method: widget.repayment ? _method : PaymentMethod.credit,
            customerId: widget.customer.id,
            note: _note.text,
            source: EntrySource.manual,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      showMessage(
        context,
        widget.repayment
            ? '${Money.format(paise)} received from ${widget.customer.name}.'
            : '${Money.format(paise)} credit added for ${widget.customer.name}.',
      );
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool repayment = widget.repayment;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              repayment ? 'Record repayment' : 'Give credit (udhaar)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              repayment
                  ? '${widget.customer.name} owes '
                      '${Money.format(widget.customer.outstandingPaise)}.'
                  : 'This increases what ${widget.customer.name} owes you.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            AmountField(controller: _amount, autofocus: true),
            if (repayment)
              LabeledField(
                label: 'Received via',
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
            LabeledField(
              label: 'Note (optional)',
              child: TextField(
                controller: _note,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(hintText: 'e.g. part payment'),
              ),
            ),
            FilledButton(
              onPressed: _busy ? null : _save,
              child: Text(repayment ? 'Record repayment' : 'Add credit'),
            ),
          ],
        ),
      ),
    );
  }
}
