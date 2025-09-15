import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/providers/account_provider.dart';
import 'entry_dialog.dart';

class EntriesList extends StatelessWidget {
  final List<AccountEntry> entries;
  final NumberFormat currencyFormat;
  final dynamic entriesNotifier;

  const EntriesList({
    super.key,
    required this.entries,
    required this.currencyFormat,
    required this.entriesNotifier,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_balance_wallet,
                size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No entries found',
                style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text('Try adjusting filters or add new entries',
                style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final isIncome = entry.type == 'Income';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            onTap: () => showEntryDialog(
              context,
              entriesNotifier,
              existing: entry,
              index: index,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isIncome
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
            title: Text(
              entry.category,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              entry.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormat.format(entry.amount),
                  style: TextStyle(
                    color: isIncome ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('dd MMM').format(entry.date),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
