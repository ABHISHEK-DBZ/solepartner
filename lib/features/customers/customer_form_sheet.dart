import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/widgets/common.dart';
import '../../domain/models.dart';

Future<int?> showCustomerForm(
  BuildContext context, {
  CustomerView? customer,
}) {
  return showModalBottomSheet<int?>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context) => CustomerFormSheet(customer: customer),
  );
}

class CustomerFormSheet extends ConsumerStatefulWidget {
  const CustomerFormSheet({super.key, this.customer});

  final CustomerView? customer;

  @override
  ConsumerState<CustomerFormSheet> createState() => _CustomerFormSheetState();
}

class _CustomerFormSheetState extends ConsumerState<CustomerFormSheet> {
  late final TextEditingController _name =
      TextEditingController(text: widget.customer?.name ?? '');
  late final TextEditingController _phone =
      TextEditingController(text: widget.customer?.phone ?? '');
  late final TextEditingController _address =
      TextEditingController(text: widget.customer?.address ?? '');
  late final TextEditingController _notes =
      TextEditingController(text: widget.customer?.notes ?? '');
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      showError(context, 'Customer name is required.');
      return;
    }
    setState(() => _busy = true);
    try {
      final repo = ref.read(customerRepositoryProvider);
      final int id;
      if (widget.customer == null) {
        id = await repo.createCustomer(
          name: _name.text,
          phone: _phone.text,
          address: _address.text,
          notes: _notes.text,
        );
      } else {
        await repo.updateCustomer(
          id: widget.customer!.id,
          name: _name.text,
          phone: _phone.text,
          address: _address.text,
          notes: _notes.text,
        );
        id = widget.customer!.id;
      }
      if (!mounted) return;
      Navigator.of(context).pop(id);
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.customer == null ? 'New customer' : 'Edit customer',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            LabeledField(
              label: 'Name',
              child: TextField(
                controller: _name,
                autofocus: widget.customer == null,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'e.g. Rahul Verma'),
              ),
            ),
            LabeledField(
              label: 'Phone (optional)',
              child: TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: '10-digit mobile'),
              ),
            ),
            LabeledField(
              label: 'Address (optional)',
              child: TextField(
                controller: _address,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(hintText: 'Area or street'),
              ),
            ),
            LabeledField(
              label: 'Notes (optional, stays on device)',
              child: TextField(
                controller: _notes,
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
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
                  : Text(widget.customer == null ? 'Add customer' : 'Save'),
            ),
            if (widget.customer != null) ...<Widget>[
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  await ref
                      .read(customerRepositoryProvider)
                      .archiveCustomer(widget.customer!.id);
                  if (!context.mounted) return;
                  Navigator.of(context).pop(widget.customer!.id);
                },
                child: Text(
                  widget.customer!.archived
                      ? 'Restore customer'
                      : 'Archive customer',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
