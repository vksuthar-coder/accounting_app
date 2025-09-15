import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/account_provider.dart';
import 'account.dart'; // barrel file exports all widgets

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(filteredEntriesProvider);
    final summary = ref.watch(summaryProvider);
    final filters = ref.watch(filtersProvider);

    final entriesNotifier = ref.read(entriesProvider.notifier);
    final filtersNotifier = ref.read(filtersProvider.notifier);

    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_off),
            onPressed: filtersNotifier.clear,
            tooltip: 'Clear Filters',
          ),
        ],
      ),
      body: Column(
        children: [
          SummaryCard(
            summary: summary,
            filters: filters,
            filtersNotifier: filtersNotifier,
            currencyFormat: currencyFormat,
          ),
          FiltersRow(
            filters: filters,
            filtersNotifier: filtersNotifier,
            entriesNotifier: entriesNotifier,
          ),
          SearchMonthRow(
            filtersNotifier: filtersNotifier,
            filters: filters,
          ),
          Expanded(
            child: EntriesList(
              entries: entries,
              currencyFormat: currencyFormat,
              entriesNotifier: entriesNotifier,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingButtons(entriesNotifier: entriesNotifier),
    );
  }
}
