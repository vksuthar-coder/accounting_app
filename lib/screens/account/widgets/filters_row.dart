import 'package:flutter/material.dart';

class FiltersRow extends StatelessWidget {
  final dynamic filters;
  final dynamic filtersNotifier;
  final dynamic entriesNotifier;

  const FiltersRow({
    super.key,
    required this.filters,
    required this.filtersNotifier,
    required this.entriesNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: filters.type,
              items: ['All', 'Income', 'Expense']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) filtersNotifier.updateType(value);
              },
              decoration: const InputDecoration(
                labelText: 'Type',
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: filters.category,
              items: [
                'All',
                ...entriesNotifier.incomeCategories,
                ...entriesNotifier.expenseCategories,
              ]
                  .map<DropdownMenuItem<String>>(
                      (category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ))
                  .toList(),
              onChanged: (value) {
                if (value != null) filtersNotifier.updateCategory(value);
              },
              decoration: const InputDecoration(
                labelText: 'Category',
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
