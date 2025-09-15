// lib/home/models/year_data.dart
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

  factory YearData.fromMap(Map<String, dynamic> map) {
    return YearData(
      income: (map['yearlyIncome'] ?? 0).toDouble(),
      expenses: (map['yearlyExpenses'] ?? 0).toDouble(),
      monthlyIncome: List<double>.from(
          (map['monthlyIncome'] ?? List.filled(12, 0)).map((e) => e.toDouble())),
      monthlyExpenses: List<double>.from(
          (map['monthlyExpenses'] ?? List.filled(12, 0)).map((e) => e.toDouble())),
      incomeCategories: Map<String, double>.from(
          (map['incomeCategories'] ?? {}).map((k, v) => MapEntry(k, (v as num).toDouble()))),
      expenseCategories: Map<String, double>.from(
          (map['expenseCategories'] ?? {}).map((k, v) => MapEntry(k, (v as num).toDouble()))),
    );
  }
}
