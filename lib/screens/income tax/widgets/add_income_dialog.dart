import 'package:flutter/material.dart';
import '/providers/tax_provider.dart';

class AddIncomeDialog extends StatelessWidget {
  final TaxNotifier notifier;

  const AddIncomeDialog({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final sourceController = TextEditingController();
    final amountController = TextEditingController();

    return AlertDialog(
      title: const Text('Add Income'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: sourceController, decoration: const InputDecoration(labelText: 'Source')),
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
            final source = sourceController.text.trim();
            final amount = double.tryParse(amountController.text.trim()) ?? 0;
            if (source.isNotEmpty && amount > 0) {
              notifier.addIncome(IncomeEntry(source: source, amount: amount));
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
