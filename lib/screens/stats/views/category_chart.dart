import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryChart extends StatefulWidget {
  final Map<String, double> categoryPercentages;

  const CategoryChart({super.key, required this.categoryPercentages});

  @override
  State<CategoryChart> createState() => _CategoryChartState();
}

class _CategoryChartState extends State<CategoryChart> {
  int touchedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: _generatePieChartSections(),
        sectionsSpace: 4,
        centerSpaceRadius: 50,
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
      ),
    );
  }

  List<PieChartSectionData> _generatePieChartSections() {
    final List<MapEntry<String, double>> entries =
        widget.categoryPercentages.entries.toList();

    return entries.asMap().entries.map((entry) {
      final int index = entry.key;
      final MapEntry<String, double> data = entry.value;
      final String categoryName = data.key;
      final String imagePath = 'assets/expenses/$categoryName.png';

      final isTouched = index == touchedIndex;

      return PieChartSectionData(
        color: _getColorForCategory(data.key),
        value: data.value,
        title: '${data.value.toStringAsFixed(2)}%',
        radius: isTouched ? 80 : 60,
        titleStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        badgeWidget: Image.asset(
          imagePath,
          scale: 2,
        ),
        badgePositionPercentageOffset: 1.11,
      );
    }).toList();
  }

  Color _getColorForCategory(String categoryName) {
    switch (categoryName) {
      case 'food':
        return Colors.blue;
      case 'shopping':
        return const Color.fromARGB(255, 218, 199, 29);
      case 'travel':
        return Colors.green;
      case 'pet':
        return Colors.indigo;
      case 'entertainment':
        return Colors.orange;
      case 'tech':
        return Colors.purple;
      case 'home':
        return Colors.cyan;
      default:
        return Colors.red;
    }
  }
}
