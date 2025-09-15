import 'package:flutter/material.dart';
import '/providers/tax_provider.dart';

class AddDeductionDialog extends StatelessWidget {
  final TaxNotifier notifier;

  const AddDeductionDialog({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    return AlertDialog(
      title: const Text('Add Deduction'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
          TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            final amount = double.tryParse(amountController.text.trim()) ?? 0;
            if (name.isNotEmpty && amount > 0) {
              notifier.addDeduction(DeductionEntry(name: name, amount: amount));
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
