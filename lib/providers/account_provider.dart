import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// -------------------- MODEL --------------------
class AccountEntry {
  final String type;
  final String category;
  final double amount;
  final String description;
  final DateTime date;

  AccountEntry({
    required this.type,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'type': type,
        'category': category,
        'amount': amount,
        'description': description,
        'date': date.toIso8601String(),
      };

  factory AccountEntry.fromMap(Map<String, dynamic> map) => AccountEntry(
        type: map['type'] ?? '',
        category: map['category'] ?? 'Other',
        amount: (map['amount'] as num?)?.toDouble() ?? 0,
        description: map['description']?.toString() ?? '',
        date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      );
}

// -------------------- ENTRIES NOTIFIER --------------------
class EntriesNotifier extends StateNotifier<List<AccountEntry>> {
  EntriesNotifier() : super([]) {
    _loadEntries();
  }

  late SharedPreferences _prefs;

  // Categories
  final List<String> incomeCategories = [
    'Salary',
    'Business',
    'Investment',
    'Other Income'
  ];

  final List<String> expenseCategories = [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Other Expense'
  ];

  Future<void> _loadEntries() async {
    _prefs = await SharedPreferences.getInstance();
    final jsonString = _prefs.getString('account_entries');
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      state = decoded.map((e) => AccountEntry.fromMap(e)).toList();
      _sortEntries();
    }
  }

  Future<void> _saveEntries() async {
    final encoded = jsonEncode(state.map((e) => e.toMap()).toList());
    await _prefs.setString('account_entries', encoded);
  }

  void _sortEntries() {
    state = [...state]..sort((a, b) => b.date.compareTo(a.date));
  }

  void addEntry(AccountEntry entry) {
    state = [...state, entry];
    _sortEntries();
    _saveEntries();
  }

  void updateEntry(int index, AccountEntry entry) {
    final newList = [...state];
    newList[index] = entry;
    state = newList;
    _sortEntries();
    _saveEntries();
  }

  void deleteEntry(int index) {
    final newList = [...state];
    newList.removeAt(index);
    state = newList;
    _saveEntries();
  }
}

final entriesProvider =
    StateNotifierProvider<EntriesNotifier, List<AccountEntry>>((ref) {
  return EntriesNotifier();
});

// -------------------- FILTERS NOTIFIER --------------------
class Filters {
  final String type;
  final String category;
  final String searchTerm;
  final DateTime? selectedMonth;

  Filters({
    this.type = 'All',
    this.category = 'All',
    this.searchTerm = '',
    this.selectedMonth,
  });

  Filters copyWith({
    String? type,
    String? category,
    String? searchTerm,
    DateTime? selectedMonth,
  }) {
    return Filters(
      type: type ?? this.type,
      category: category ?? this.category,
      searchTerm: searchTerm ?? this.searchTerm,
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }
}

class FiltersNotifier extends StateNotifier<Filters> {
  FiltersNotifier() : super(Filters());

  void updateType(String type) => state = state.copyWith(type: type);
  void updateCategory(String category) =>
      state = state.copyWith(category: category);
  void updateSearch(String term) => state = state.copyWith(searchTerm: term);
  void updateMonth(DateTime? month) => state = state.copyWith(selectedMonth: month);
  void clear() => state = Filters();
}

final filtersProvider = StateNotifierProvider<FiltersNotifier, Filters>((ref) {
  return FiltersNotifier();
});

// -------------------- FILTERED ENTRIES --------------------
final filteredEntriesProvider = Provider<List<AccountEntry>>((ref) {
  final entries = ref.watch(entriesProvider);
  final filters = ref.watch(filtersProvider);

  return entries.where((entry) {
    if (filters.type != 'All' && entry.type != filters.type) return false;
    if (filters.category != 'All' && entry.category != filters.category) return false;
    if (filters.searchTerm.isNotEmpty &&
        !entry.description.toLowerCase().contains(filters.searchTerm.toLowerCase())) return false;
    if (filters.selectedMonth != null) {
      if (entry.date.year != filters.selectedMonth!.year ||
          entry.date.month != filters.selectedMonth!.month) return false;
    }
    return true;
  }).toList();
});

// -------------------- SUMMARY PROVIDER --------------------
final summaryProvider = Provider<Map<String, double>>((ref) {
  final entries = ref.watch(filteredEntriesProvider);
  double income = 0;
  double expense = 0;

  for (var entry in entries) {
    if (entry.type == 'Income') {
      income += entry.amount;
    } else {
      expense += entry.amount;
    }
  }

  return {
    'income': income,
    'expense': expense,
    'balance': income - expense,
  };
});
final yearlyDataProvider = Provider<Map<int, dynamic>>((ref) {
  final entries = ref.watch(entriesProvider);

  final Map<int, List<AccountEntry>> entriesByYear = {};

  for (var entry in entries) {
    entriesByYear.putIfAbsent(entry.date.year, () => []).add(entry);
  }

  final Map<int, dynamic> yearlyData = {};

  entriesByYear.forEach((year, yearEntries) {
    double income = 0;
    double expenses = 0;
    final monthlyIncome = List<double>.filled(12, 0);
    final monthlyExpenses = List<double>.filled(12, 0);
    final incomeCategories = <String, double>{};
    final expenseCategories = <String, double>{};

    for (var entry in yearEntries) {
      final amount = entry.amount;
      final month = entry.date.month - 1;

      if (entry.type == 'Income') {
        income += amount;
        monthlyIncome[month] += amount;
        incomeCategories.update(entry.category, (v) => v + amount, ifAbsent: () => amount);
      } else {
        expenses += amount;
        monthlyExpenses[month] += amount;
        expenseCategories.update(entry.category, (v) => v + amount, ifAbsent: () => amount);
      }
    }

    yearlyData[year] = {
      'yearlyIncome': income,
      'yearlyExpenses': expenses,
      'monthlyIncome': monthlyIncome,
      'monthlyExpenses': monthlyExpenses,
      'incomeCategories': incomeCategories,
      'expenseCategories': expenseCategories,
    };
  });

  return yearlyData;
});
