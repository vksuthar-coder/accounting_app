import 'package:flutter/material.dart';
import '/providers/tax_provider.dart';
import 'add_income_dialog.dart';

class IncomeList extends StatelessWidget {
  final TaxState taxState;
  final TaxNotifier taxNotifier;

  const IncomeList({super.key, required this.taxState, required this.taxNotifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Income Sources', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: taxState.incomes.length,
          itemBuilder: (_, index) {
            final entry = taxState.incomes[index];
            return ListTile(
              title: Text(entry.source),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('₹${entry.amount.toStringAsFixed(2)}'),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => taxNotifier.removeIncome(entry),
                  ),
                ],
              ),
            );
          },
        ),
        ElevatedButton(
          onPressed: () => _showAddIncomeDialog(context, taxNotifier),
          child: const Text('Add Income'),
        ),
      ],
    );
  }

  void _showAddIncomeDialog(BuildContext context, TaxNotifier notifier) {
    showDialog(
      context: context,
      builder: (_) => AddIncomeDialog(notifier: notifier),
    );
  }
}
