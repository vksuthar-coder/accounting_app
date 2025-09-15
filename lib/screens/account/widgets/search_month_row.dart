import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class SearchMonthRow extends StatelessWidget {
  final dynamic filtersNotifier;
  final dynamic filters;

  const SearchMonthRow({
    super.key,
    required this.filtersNotifier,
    required this.filters,
  });

  Future<void> _pickMonth(BuildContext context) async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: filters.selectedMonth ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      filtersNotifier.updateMonth(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              onChanged: (value) => filtersNotifier.updateSearch(value),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => _pickMonth(context),
            tooltip: 'Filter by Month',
          ),
        ],
      ),
    );
  }
}
