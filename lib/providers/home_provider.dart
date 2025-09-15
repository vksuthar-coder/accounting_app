import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YearData {
  final double income;
  final double expenses;
  final List<double> monthlyIncome;
  final List<double> monthlyExpenses;
  final Map<String, double> incomeCategories;
  final Map<String, double> expenseCategories;

  YearData({
    required this.income,
    required this.expenses,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.incomeCategories,
    required this.expenseCategories,
  });

  Map<String, dynamic> toMap() => {
        'yearlyIncome': income,
        'yearlyExpenses': expenses,
        'monthlyIncome': monthlyIncome,
        'monthlyExpenses': monthlyExpenses,
        'incomeCategories': incomeCategories,
        'expenseCategories': expenseCategories,
      };

  factory YearData.fromMap(Map<String, dynamic> map) => YearData(
        income: (map['yearlyIncome'] ?? 0).toDouble(),
        expenses: (map['yearlyExpenses'] ?? 0).toDouble(),
        monthlyIncome: List<double>.from(
            (map['monthlyIncome'] ?? List.filled(12, 0))
                .map((e) => e.toDouble())),
        monthlyExpenses: List<double>.from(
            (map['monthlyExpenses'] ?? List.filled(12, 0))
                .map((e) => e.toDouble())),
        incomeCategories: Map<String, double>.from(
            map['incomeCategories']?.map((k, v) => MapEntry(k, v.toDouble())) ??
                {}),
        expenseCategories: Map<String, double>.from(
            map['expenseCategories']
                    ?.map((k, v) => MapEntry(k, v.toDouble())) ??
                {}),
      );
}

class HomeState {
  final Map<int, YearData> yearsData;
  final int selectedYear;
  final int selectedIndex;
  final bool loading;

  HomeState({
    required this.yearsData,
    required this.selectedYear,
    required this.selectedIndex,
    this.loading = false,
  });

  HomeState copyWith({
    Map<int, YearData>? yearsData,
    int? selectedYear,
    int? selectedIndex,
    bool? loading,
  }) {
    return HomeState(
      yearsData: yearsData ?? this.yearsData,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      loading: loading ?? this.loading,
    );
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(),
);

class HomeNotifier extends StateNotifier<HomeState> {
  static const _prefsKey = 'yearsData';

  HomeNotifier()
      : super(HomeState(
          yearsData: {},
          selectedYear: DateTime.now().year,
          selectedIndex: 0,
        )) {
    _loadYearsData();
  }

  Future<void> _loadYearsData() async {
    state = state.copyWith(loading: true);
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString(_prefsKey);
    if (dataString != null) {
      final decoded = jsonDecode(dataString) as Map<String, dynamic>;
      final Map<int, YearData> loaded = {};
      decoded.forEach((year, map) {
        loaded[int.parse(year)] = YearData.fromMap(map);
      });
      state = state.copyWith(
        yearsData: loaded,
        selectedYear: loaded.isNotEmpty
            ? loaded.keys.reduce((a, b) => a > b ? a : b)
            : DateTime.now().year,
      );
    }
    state = state.copyWith(loading: false);
  }

  Future<void> _saveYearsData() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> encoded = {};
    state.yearsData.forEach((year, data) {
      encoded[year.toString()] = data.toMap();
    });
    await prefs.setString(_prefsKey, jsonEncode(encoded));
  }

  void setYearsData(Map<int, YearData> newData) {
    state = state.copyWith(yearsData: newData);
    _saveYearsData();
  }

  void setSelectedYear(int year) {
    state = state.copyWith(selectedYear: year);
  }

  void setIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }
}
