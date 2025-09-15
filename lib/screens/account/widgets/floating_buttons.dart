import 'package:flutter/material.dart';
import 'entry_dialog.dart';

class FloatingButtons extends StatelessWidget {
  final dynamic entriesNotifier;

  const FloatingButtons({
    super.key,
    required this.entriesNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'addIncome',
          onPressed: () =>
              showEntryDialog(context, entriesNotifier, type: 'Income'),
          backgroundColor: Colors.green,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        const SizedBox(width: 16),
        FloatingActionButton(
          heroTag: 'addExpense',
          onPressed: () =>
              showEntryDialog(context, entriesNotifier, type: 'Expense'),
          backgroundColor: Colors.red,
          child: const Icon(Icons.remove, color: Colors.white),
        ),
      ],
    );
  }
}
