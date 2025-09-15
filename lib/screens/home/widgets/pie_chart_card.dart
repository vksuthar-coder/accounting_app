// lib/home/widgets/pie_chart_card.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../models/year_data.dart';

class PieChartCard extends StatelessWidget {
  final YearData? data;
  final bool isLoading;
  
  const PieChartCard({
    super.key, 
    required this.data,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildShimmerCard(context);
    }
    
    if (data == null) return const SizedBox(height: 280);

    final income = data!.income;
    final expenses = data!.expenses;
    final total = income + expenses;
    final profit = income - expenses;

    if (total == 0) return _buildEmptyState(context);

    return _buildDataCard(context, income, expenses, profit, total);
  }

  Widget _buildShimmerCard(BuildContext context) {
    return Container(
      height: 280,
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
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surfaceContainer,
        highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Row(
          children: [
            // Shimmer for pie chart
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Shimmer for legend
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerLegend(),
                  const SizedBox(height: 16),
                  _buildShimmerLegend(),
                  const SizedBox(height: 16),
                  _buildShimmerLegend(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLegend() {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 280,
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No financial data available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add income or expenses to see your financial overview',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard(BuildContext context, double income, double expenses, double profit, double total) {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      height: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Pie Chart
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: [
                      if (income > 0)
                        PieChartSectionData(
                          value: income,
                          color: _blendColors(Colors.green, colors.primary),
                          title: '${(income / total * 100).toStringAsFixed(1)}%',
                          radius: 40,
                          titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(1, 1),
                              )
                            ],
                          ),
                          badgeWidget: _ChartBadge(
                            icon: Icons.arrow_upward_rounded,
                            color: const Color.fromARGB(255, 10, 153, 65),
                          ),
                          badgePositionPercentageOffset: 1.2,
                        ),
                      if (expenses > 0)
                        PieChartSectionData(
                          value: expenses,
                          color: _blendColors(Colors.red, colors.error),
                          title: '${(expenses / total * 100).toStringAsFixed(1)}%',
                          radius: 40,
                          titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(1, 1),
                              )
                            ],
                          ),
                          badgeWidget: _ChartBadge(
                            icon: Icons.arrow_downward_rounded,
                            color: const Color.fromARGB(255, 236, 6, 6),
                          ),
                          badgePositionPercentageOffset: 1.2,
                        ),
                    ],
                    centerSpaceRadius: 50,
                    sectionsSpace: 1,
                    borderData: FlBorderData(show: false),
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatter.format(total),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Legend
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegend(
                  _blendColors(Colors.green, colors.primary),
                  Icons.arrow_upward_rounded,
                  'Income',
                  formatter.format(income),
                  context,
                ),
                const SizedBox(height: 16),
                _buildLegend(
                  _blendColors(Colors.red, colors.error),
                  Icons.arrow_downward_rounded,
                  'Expenses',
                  formatter.format(expenses),
                  context,
                ),
                const SizedBox(height: 16),
                _buildLegend(
                  profit >= 0 
                    ? _blendColors(Colors.blue, colors.primary) 
                    : _blendColors(Colors.orange, colors.error),
                  profit >= 0 ? Icons.account_balance_wallet : Icons.warning_rounded,
                  'Balance',
                  formatter.format(profit),
                  context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, IconData icon, String title, String value, BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _blendColors(Color color1, Color color2) {
    return Color.alphaBlend(color1.withOpacity(0.7), color2);
  }
}

class _ChartBadge extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _ChartBadge({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 14,
        color: Colors.white,
      ),
    );
  }
}