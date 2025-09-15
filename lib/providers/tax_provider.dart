import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Model: Income Source
class IncomeEntry {
  final String source;
  final double amount;

  IncomeEntry({required this.source, required this.amount});

  Map<String, dynamic> toJson() => {
        'source': source,
        'amount': amount,
      };

  factory IncomeEntry.fromJson(Map<String, dynamic> json) => IncomeEntry(
        source: json['source'],
        amount: (json['amount'] as num).toDouble(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomeEntry &&
          runtimeType == other.runtimeType &&
          source == other.source &&
          amount == other.amount;

  @override
  int get hashCode => source.hashCode ^ amount.hashCode;
}

/// Model: Deduction
class DeductionEntry {
  final String name;
  final double amount;

  DeductionEntry({required this.name, required this.amount});

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
      };

  factory DeductionEntry.fromJson(Map<String, dynamic> json) => DeductionEntry(
        name: json['name'],
        amount: (json['amount'] as num).toDouble(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeductionEntry &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          amount == other.amount;

  @override
  int get hashCode => name.hashCode ^ amount.hashCode;
}

/// State
class TaxState {
  final List<IncomeEntry> incomes;
  final List<DeductionEntry> deductions;
  final bool loading;

  TaxState({
    required this.incomes,
    required this.deductions,
    required this.loading,
  });

  TaxState copyWith({
    List<IncomeEntry>? incomes,
    List<DeductionEntry>? deductions,
    bool? loading,
  }) {
    return TaxState(
      incomes: incomes ?? this.incomes,
      deductions: deductions ?? this.deductions,
      loading: loading ?? this.loading,
    );
  }

  double get totalIncome =>
      incomes.fold(0.0, (sum, entry) => sum + entry.amount);

  double get totalDeductions =>
      deductions.fold(0.0, (sum, entry) => sum + entry.amount);

  double get taxableIncome {
    double taxable = totalIncome - totalDeductions - 75000; // Standard deduction
    return taxable > 0 ? taxable : 0;
  }

  double calculateTax() {
    double tax = 0.0;
    double income = taxableIncome;

    // New Tax Regime FY 2025-26 slabs
    if (income <= 400000) {
      tax = 0;
    } else if (income <= 800000) {
      tax = (income - 400000) * 0.05;
    } else if (income <= 1200000) {
      tax = 400000 * 0.05 + (income - 800000) * 0.10;
    } else if (income <= 1600000) {
      tax = 400000 * 0.05 + 400000 * 0.10 + (income - 1200000) * 0.15;
    } else if (income <= 2000000) {
      tax = 400000 * 0.05 + 400000 * 0.10 + 400000 * 0.15 + (income - 1600000) * 0.20;
    } else if (income <= 2400000) {
      tax = 400000 * 0.05 + 400000 * 0.10 + 400000 * 0.15 + 400000 * 0.20 + (income - 2000000) * 0.25;
    } else {
      tax = 400000 * 0.05 + 400000 * 0.10 + 400000 * 0.15 + 400000 * 0.20 + 400000 * 0.25 + (income - 2400000) * 0.30;
    }

    // Section 87A rebate (income <= 12 lakh)
    if (income <= 1200000) {
      tax -= 25000;
      if (tax < 0) tax = 0;
    }

    return tax;
  }
}

/// Provider
final taxProvider =
    StateNotifierProvider<TaxNotifier, TaxState>((ref) => TaxNotifier());

class TaxNotifier extends StateNotifier<TaxState> {
  static const _prefsKey = "tax_entries";

  TaxNotifier()
      : super(TaxState(incomes: [], deductions: [], loading: false)) {
    loadEntries();
  }

  /// Load incomes & deductions from local storage
  Future<void> loadEntries() async {
    state = state.copyWith(loading: true);
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_prefsKey);
    if (data != null) {
      final Map decoded = jsonDecode(data);
      final incomes = (decoded['incomes'] as List)
          .map((e) => IncomeEntry.fromJson(e))
          .toList();
      final deductions = (decoded['deductions'] as List)
          .map((e) => DeductionEntry.fromJson(e))
          .toList();
      state = state.copyWith(
        incomes: incomes,
        deductions: deductions,
        loading: false,
      );
    } else {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> _cacheEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'incomes': state.incomes.map((e) => e.toJson()).toList(),
      'deductions': state.deductions.map((e) => e.toJson()).toList(),
    };
    await prefs.setString(_prefsKey, jsonEncode(data));
  }

  /// Add Income
  Future<void> addIncome(IncomeEntry entry) async {
    final updated = [...state.incomes, entry];
    state = state.copyWith(incomes: updated);
    await _cacheEntries();
  }

  /// Remove Income
  Future<void> removeIncome(IncomeEntry entry) async {
    final updated = state.incomes.where((e) => e != entry).toList();
    state = state.copyWith(incomes: updated);
    await _cacheEntries();
  }

  /// Add Deduction
  Future<void> addDeduction(DeductionEntry entry) async {
    final updated = [...state.deductions, entry];
    state = state.copyWith(deductions: updated);
    await _cacheEntries();
  }

  /// Remove Deduction
  Future<void> removeDeduction(DeductionEntry entry) async {
    final updated = state.deductions.where((e) => e != entry).toList();
    state = state.copyWith(deductions: updated);
    await _cacheEntries();
  }
}
