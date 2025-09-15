import 'package:flutter/material.dart';
import '/providers/tax_provider.dart';
import 'add_deduction_dialog.dart';
import 'DeductionDetailScreen.dart';
class DeductionList extends StatelessWidget {
  final TaxState taxState;
  final TaxNotifier taxNotifier;

  const DeductionList({super.key, required this.taxState, required this.taxNotifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Deductions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                // Navigate to your deduction detail screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DeductionDetailScreen(), // You will implement this
                  ),
                );
              },
              child: const Icon(Icons.help_outline, color: Colors.blue, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          '(Old Tax Regime only – most deductions are not allowed in the new regime)',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: taxState.deductions.length,
          itemBuilder: (_, index) {
            final entry = taxState.deductions[index];
            return ListTile(
              title: Text(entry.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('₹${entry.amount.toStringAsFixed(2)}'),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => taxNotifier.removeDeduction(entry),
                  ),
                ],
              ),
            );
          },
        ),
        ElevatedButton(
          onPressed: () => _showAddDeductionDialog(context, taxNotifier),
          child: const Text('Add Deduction'),
        ),
      ],
    );
  }

  void _showAddDeductionDialog(BuildContext context, TaxNotifier notifier) {
    showDialog(
      context: context,
      builder: (_) => AddDeductionDialog(notifier: notifier),
    );
  }
}
