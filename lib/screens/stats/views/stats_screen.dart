import 'package:expense_tracker_app/bloc/get_expense/get_expense_bloc.dart';
import 'package:expense_tracker_app/bloc/get_expense/get_expense_state.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/screens/stats/views/category_chart.dart';
import 'package:expense_tracker_app/screens/stats/views/date_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = true;
  bool _isDailyView = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {
      _showLeftArrow = _scrollController.position.pixels > 0;
      _showRightArrow = _scrollController.position.pixels <
          _scrollController.position.maxScrollExtent;

      _isDailyView = _scrollController.position.pixels <
          MediaQuery.of(context).size.width / 2;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Expense> _calculateDailyExpenses(List<Expense> expenses) {
    final today = DateTime.now();
    return expenses.where((expense) {
      return expense.date.year == today.year &&
          expense.date.month == today.month &&
          expense.date.day == today.day;
    }).toList();
  }

  List<Expense> _calculateWeeklyExpenses(List<Expense> expenses) {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return expenses.where((expense) {
      return expense.date
              .isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          expense.date.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();
  }

  Map<String, double> _calculateCategoryPercentages(List<Expense> expenses) {
    final categoryAmountMap = <String, int>{};
    double totalAmount = 0;

    for (var expense in expenses) {
      totalAmount += expense.amount;
      if (categoryAmountMap.containsKey(expense.category.icon)) {
        categoryAmountMap[expense.category.icon] =
            categoryAmountMap[expense.category.icon]! + expense.amount;
      } else {
        categoryAmountMap[expense.category.icon] = expense.amount;
      }
    }

    final categoryPercentageMap = <String, double>{};
    categoryAmountMap.forEach((icon, amount) {
      categoryPercentageMap[icon] = (amount / totalAmount) * 100;
    });

    return categoryPercentageMap;
  }

  @override
  Widget build(BuildContext context) {
    final expenseState = context.watch<GetExpensesBloc>().state;
    List<Expense> dailyExpenses = [];
    List<Expense> weeklyExpenses = [];

    if (expenseState is GetExpensesSuccess) {
      dailyExpenses = _calculateDailyExpenses(expenseState.expenses);
      weeklyExpenses = _calculateWeeklyExpenses(expenseState.expenses);
    }

    final dailyCategoryPercentages =
        _calculateCategoryPercentages(dailyExpenses);
    // final weeklyCategoryPercentages =
    //     _calculateCategoryPercentages(weeklyExpenses);

    final Map<String, int> dailyTotals = {};
    for (var expense in weeklyExpenses) {
      String date =
          "${expense.date.day}-${expense.date.month}-${expense.date.year}";
      if (dailyTotals.containsKey(date)) {
        dailyTotals[date] = dailyTotals[date]! + expense.amount;
      } else {
        dailyTotals[date] = expense.amount;
      }
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              _isDailyView
                  ? 'Today\'s Expense chart >'
                  : '< Weekly Expense chart',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 1.16,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 70),
                          child: CategoryChart(
                            categoryPercentages: dailyCategoryPercentages,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 1.16,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 70, bottom: 40, left: 90, right: 10),
                          child: DateChart(
                            weeklyExpenses: weeklyExpenses,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: -10,
                  top: MediaQuery.of(context).size.width / 2 - 50,
                  child: Visibility(
                    visible: _showLeftArrow,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () {
                        _scrollController.animateTo(
                          _scrollController.position.pixels -
                              MediaQuery.of(context).size.width,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  top: MediaQuery.of(context).size.width / 2 - 50,
                  child: Visibility(
                    visible: _showRightArrow,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      onPressed: () {
                        _scrollController.animateTo(
                          _scrollController.position.pixels +
                              MediaQuery.of(context).size.width,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              _isDailyView
                  ? 'Transaction Daily Details'
                  : 'Transaction Weekly Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _isDailyView
                ? Expanded(
                    child: ListView.builder(
                      itemCount: dailyCategoryPercentages.length,
                      itemBuilder: (context, index) {
                        final categoryName =
                            dailyCategoryPercentages.keys.elementAt(index);
                        final percentage =
                            dailyCategoryPercentages[categoryName]!;
                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            leading: Icon(
                              FontAwesomeIcons.cloud,
                              color: color(categoryName),
                            ),
                            title: Text(
                              '$categoryName: ${percentage.toStringAsFixed(2)}%',
                              style: TextStyle(
                                  color: color(categoryName),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: dailyTotals.length,
                      itemBuilder: (context, index) {
                        final date = dailyTotals.keys.elementAt(index);
                        final total = dailyTotals[date]!;

                        final Map<String, double> categoryTotalsForDate = {};
                        weeklyExpenses.forEach((expense) {
                          final expenseDate =
                              "${expense.date.day}-${expense.date.month}-${expense.date.year}";
                          if (expenseDate == date) {
                            if (categoryTotalsForDate
                                .containsKey(expense.category.icon)) {
                              categoryTotalsForDate[expense.category.icon] =
                                  (categoryTotalsForDate[
                                              expense.category.icon] ??
                                          0) +
                                      expense.amount;
                            } else {
                              categoryTotalsForDate[expense.category.icon] =
                                  expense.amount.toDouble();
                            }
                          }
                        });

                        return Card(
                          color: Colors.white,
                          child: ExpansionTile(
                            expandedAlignment: Alignment.bottomLeft,
                            title: Text(
                              'Date: $date',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Total: ₹${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: categoryTotalsForDate.keys
                                      .map((categoryName) {
                                    final amount =
                                        categoryTotalsForDate[categoryName]!;
                                    return Text(
                                      '$categoryName: ₹${amount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: color(categoryName),
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Color color(String categoryName) {
    switch (categoryName) {
      case 'food':
        return Colors.blue;
      case 'shopping':
        return const Color.fromARGB(255, 197, 178, 16);
      case 'travel':
        return Colors.green;
      case 'pet':
        return Colors.indigo;
      case 'entertainment ':
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
