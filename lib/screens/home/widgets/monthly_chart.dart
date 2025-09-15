// lib/home/widgets/monthly_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/year_data.dart';

class MonthlyChart extends StatelessWidget {
  final YearData? data;
  final bool isLoading;
  
  const MonthlyChart({
    super.key, 
    required this.data,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildShimmerChart();
    }
    
    if (data == null) return const SizedBox(height: 880);

    final allMonthly = [...data!.monthlyIncome, ...data!.monthlyExpenses];
    final maxY = allMonthly.fold<double>(0, (prev, e) => e > prev ? e : prev) * 1.2;

    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Income vs Expenses Comparison',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          
          // Legend
          _buildLegend(context),
          const SizedBox(height: 20),
          
          // Quarterly Charts
          _buildQuarterlyChart(context, 'Q1: Jan - Mar', 0, 3, months, maxY),
          const SizedBox(height: 24),
          _buildQuarterlyChart(context, 'Q2: Apr - Jun', 3, 6, months, maxY),
          const SizedBox(height: 24),
          _buildQuarterlyChart(context, 'Q3: Jul - Sep', 6, 9, months, maxY),
          const SizedBox(height: 24),
          _buildQuarterlyChart(context, 'Q4: Oct - Dec', 9, 12, months, maxY),
        ],
      ),
    );
  }

  Widget _buildShimmerChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 24,
            color: Colors.grey[200],
          ),
          const SizedBox(height: 8),
          Container(
            width: 150,
            height: 16,
            color: Colors.grey[200],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildShimmerLegendItem(),
              const SizedBox(width: 16),
              _buildShimmerLegendItem(),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(4, (index) => Column(
            children: [
              Container(
                width: double.infinity,
                height: 180,
                color: Colors.grey[200],
                margin: const EdgeInsets.only(bottom: 24),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildShimmerLegendItem() {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: Colors.grey[300],
        ),
        const SizedBox(width: 8),
        Container(
          width: 60,
          height: 14,
          color: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      children: [
        _buildLegendItem(
          Colors.green[600]!,
          'Income',
          context,
        ),
        const SizedBox(width: 16),
        _buildLegendItem(
          Colors.red[500]!,
          'Expenses',
          context,
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text, BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuarterlyChart(BuildContext context, String title, int start, int end, List<String> months, double maxY) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 180,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: BarChart(
            BarChartData(
              maxY: maxY,
              minY: 0,
              barGroups: List.generate(end - start, (index) {
                final i = start + index;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: data!.monthlyIncome[i],
                      color: _blendColors(Colors.green, theme.colorScheme.primary),
                      width: 10,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(1),
                        topRight: Radius.circular(1),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxY,
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                    BarChartRodData(
                      toY: data!.monthlyExpenses[i],
                      color: _blendColors(Colors.red, theme.colorScheme.error),
                      width: 10,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(1),
                        topRight: Radius.circular(1),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxY,
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ],
                );
              }),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          months[start + value.toInt()],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    },
                    reservedSize: 32,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox();
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY / 4,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.2),
                  width: 1,
                ),
              ),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final month = months[start + group.x.toInt()];
                    final type = rodIndex == 0 ? 'Income' : 'Expenses';
                    final value = rod.toY;
                    
                    return BarTooltipItem(
                      '$month - $type\n',
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: value.toStringAsFixed(0),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  },
                  tooltipPadding: const EdgeInsets.all(8),
                  tooltipMargin: 8,
                  tooltipRoundedRadius: 8,
                  tooltipBorder: BorderSide(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                  
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _blendColors(Color color1, Color color2) {
    return Color.alphaBlend(color1.withOpacity(0.7), color2);
  }
}