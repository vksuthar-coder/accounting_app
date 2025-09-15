// lib/home/widgets/category_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryChart extends StatefulWidget {
  final bool isIncome;
  final Map<String, double> categories;

  const CategoryChart({
    super.key,
    required this.isIncome,
    required this.categories,
  });

  @override
  State<CategoryChart> createState() => _CategoryChartState();
}

class _CategoryChartState extends State<CategoryChart> {
  int? _touchedGroupIndex; // Track currently touched group

  List<Color> _getColorPalette(int length) {
    final baseColor = widget.isIncome
        ? const Color(0xFF4CAF50)
        : const Color(0xFFF44336);

    final colors = List.generate(length, (index) {
      final hueShift = (index * 30) % 360;
      return HSLColor.fromColor(baseColor)
          .withHue((HSLColor.fromColor(baseColor).hue + hueShift) % 360)
          .withLightness(0.6 + (index % 3) * 0.1)
          .toColor();
    });
    return colors;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isIncome ? 'Income Categories' : 'Expense Categories',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'No data available',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final entries = widget.categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxY = entries.fold<double>(0, (prev, e) => e.value > prev ? e.value : prev) * 1.2;
    final colorPalette = _getColorPalette(entries.length);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isIncome ? 'Income Categories' : 'Expense Categories',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                minY: 0,
                barGroups: entries.map((entry) {
                  final index = entries.indexOf(entry);
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        color: colorPalette[index],
                        width: 10,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(1),
                          topRight: Radius.circular(1),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxY,
                          color: Colors.grey[100],
                        ),
                      ),
                    ],
                    showingTooltipIndicators:
                        _touchedGroupIndex == index ? [0] : [],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final category = entries[value.toInt()].key;
                        final abbreviated = category.length > 8
                            ? '${category.substring(0, 7)}...'
                            : category;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            abbreviated,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox();
                        return Text(
                          value % 1 == 0
                              ? value.toInt().toString()
                              : value.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
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
                      color: Colors.grey[100],
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  handleBuiltInTouches: false,
                  touchCallback: (event, response) {
                    if (event.isInterestedForInteractions &&
                        response != null &&
                        response.spot != null) {
                      setState(() {
                        _touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                      });
                    } else {
                      setState(() {
                        _touchedGroupIndex = null;
                      });
                    }
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${entries[groupIndex].key}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: rod.toY.toStringAsFixed(2),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    tooltipRoundedRadius: 8,
                    tooltipBorder: const BorderSide(
                      color: Colors.white30,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
