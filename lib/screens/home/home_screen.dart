import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/account_provider.dart';
import 'models/year_data.dart';
import 'widgets/pie_chart_card.dart';
import 'widgets/category_chart.dart';
import 'widgets/monthly_chart.dart';
import '/screens/profile_screen.dart';
import 'widgets/bottom_nav_widget.dart'; // ✅ Import the navigation widget

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final yearlyDataMap = ref.watch(yearlyDataProvider);
    final currentYear = DateTime.now().year;

    YearData? data;
    if (yearlyDataMap.containsKey(currentYear)) {
      data = YearData.fromMap(
        Map<String, dynamic>.from(yearlyDataMap[currentYear]!),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PieChartCard(data: data),
            const SizedBox(height: 20),
            if (data != null)
              CategoryChart(isIncome: true, categories: data.incomeCategories),
            const SizedBox(height: 20),
            if (data != null)
              CategoryChart(isIncome: false, categories: data.expenseCategories),
            const SizedBox(height: 20),
            MonthlyChart(data: data),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWidget(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
