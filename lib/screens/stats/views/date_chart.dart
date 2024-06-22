import 'dart:math';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DateChart extends StatefulWidget {
  final List<Expense> weeklyExpenses;

  const DateChart({super.key, required this.weeklyExpenses});

  @override
  State<DateChart> createState() => _DateChartState();
}

class _DateChartState extends State<DateChart> {
  @override
  Widget build(BuildContext context) {
    return BarChart(dateBarData());
  }

  BarChartData dateBarData() {
    return BarChartData(
        titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 38,
                    getTitlesWidget: bottomTiles)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 38,
                    getTitlesWidget: leftTiles))),
        borderData: FlBorderData(
          show: false,
        ),
        gridData: const FlGridData(show: false),
        barGroups: showingGroups());
  }

  Widget bottomTiles(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12);
    Widget text;

    switch (value.toInt()) {
      case 0:
        text = const Text(
          'Mon',
          style: style,
        );
        break;
      case 1:
        text = const Text(
          'Tue',
          style: style,
        );
        break;
      case 2:
        text = const Text(
          'Wed',
          style: style,
        );
        break;
      case 3:
        text = const Text(
          'Thu',
          style: style,
        );
        break;
      case 4:
        text = const Text(
          'Fri',
          style: style,
        );
        break;
      case 5:
        text = const Text(
          'Sat',
          style: style,
        );
        break;
      case 6:
        text = const Text(
          'Sun',
          style: style,
        );
        break;
      default:
        text = const Text(
          '',
          style: style,
        );
        break;
    }

    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  Widget leftTiles(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 2,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  List<BarChartGroupData> showingGroups() {
    return List.generate(7, (i) {
      return makeGroupData(i, calculateDailyTotal(widget.weeklyExpenses, i));
    });
  }

  double calculateDailyTotal(List<Expense> weeklyExpenses, int dayIndex) {
    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime targetDate = startOfWeek.add(Duration(days: dayIndex));

    double total = 0.0;

    for (var expense in weeklyExpenses) {
      if (expense.date.year == targetDate.year &&
          expense.date.month == targetDate.month &&
          expense.date.day == targetDate.day) {
        total += expense.amount;
      }
    }

    return total;
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
            transform: const GradientRotation(pi / 8),
          ),
          width: 10,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: Colors.grey[300]!,
          ),
        ),
      ],
    );
  }
}
