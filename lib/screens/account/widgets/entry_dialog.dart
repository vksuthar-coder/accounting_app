import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/providers/account_provider.dart';

void showEntryDialog(
  BuildContext context,
  dynamic entriesNotifier, {
  AccountEntry? existing,
  int? index,
  String? type,
}) {
  final isEdit = existing != null;
  final dialogType = type ?? existing?.type ?? 'Income';

  final amountController =
      TextEditingController(text: existing?.amount.toString() ?? '');
  final descController =
      TextEditingController(text: existing?.description ?? '');

  String selectedCategory = existing?.category ??
      (dialogType == 'Income'
          ? entriesNotifier.incomeCategories.first.toString()
          : entriesNotifier.expenseCategories.first.toString());

  DateTime selectedDate = existing?.date ?? DateTime.now();

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) {
        Future<void> _pickDate() async {
          final picked = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (picked != null) {
            setDialogState(() => selectedDate = picked);
          }
        }

        return AlertDialog(
          title: Row(
            children: [
              Text(isEdit ? 'Edit Entry' : 'Add New Entry'),
              if (isEdit) const Spacer(),
              if (isEdit)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    entriesNotifier.deleteEntry(index!);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: (dialogType == 'Income'
                          ? entriesNotifier.incomeCategories
                          : entriesNotifier.expenseCategories)
                      .map<DropdownMenuItem<String>>((dynamic category) {
                    final catStr = category.toString();
                    return DropdownMenuItem<String>(
                      value: catStr,
                      child: Text(catStr),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(DateFormat('dd MMM yyyy').format(selectedDate)),
                  trailing: TextButton(
                    child: const Text('Change'),
                    onPressed: _pickDate,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid amount')),
                  );
                  return;
                }

                final newEntry = AccountEntry(
                  type: dialogType,
                  category: selectedCategory,
                  amount: amount,
                  description: descController.text.trim(),
                  date: selectedDate,
                );

                if (index != null) {
                  entriesNotifier.updateEntry(index, newEntry);
                } else {
                  entriesNotifier.addEntry(newEntry);
                }

                Navigator.pop(context);
              },
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    ),
  );
}
