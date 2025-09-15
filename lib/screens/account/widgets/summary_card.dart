import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryCard extends StatelessWidget {
  final Map<String, double> summary;
  final dynamic filters;
  final dynamic filtersNotifier;
  final NumberFormat currencyFormat;

  const SummaryCard({
    super.key,
    required this.summary,
    required this.filters,
    required this.filtersNotifier,
    required this.currencyFormat,
  });

  Widget _buildSummaryItem(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          currencyFormat.format(value),
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryItem('Income', summary['income']!, Colors.green),
                _buildSummaryItem('Expense', summary['expense']!, Colors.red),
                _buildSummaryItem(
                  'Balance',
                  summary['balance']!,
                  summary['balance']! >= 0 ? Colors.blue : Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (filters.selectedMonth != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('MMMM yyyy').format(filters.selectedMonth!),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => filtersNotifier.updateMonth(null),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
