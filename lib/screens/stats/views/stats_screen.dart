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

  Map<String, double> _calculateCategoryPercentages(
      List<Expense> dailyExpenses) {
    final categoryAmountMap = <String, int>{};
    double totalAmount = 0;

    for (var expense in dailyExpenses) {
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

    if (expenseState is GetExpensesSuccess) {
      dailyExpenses = _calculateDailyExpenses(expenseState.expenses);
    }

    final categoryPercentages = _calculateCategoryPercentages(dailyExpenses);
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
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 70),
                          child: CategoryChart(
                            categoryPercentages: categoryPercentages,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 30),
                          child: DateChart(),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  top: MediaQuery.of(context).size.width / 2 - 20,
                  child: Visibility(
                    visible: _showLeftArrow,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () {
                        _scrollController.animateTo(
                          _scrollController.position.pixels -
                              MediaQuery.of(context).size.width,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: MediaQuery.of(context).size.width / 2 - 20,
                  child: Visibility(
                    visible: _showRightArrow,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios_rounded),
                      onPressed: () {
                        _scrollController.animateTo(
                          _scrollController.position.pixels +
                              MediaQuery.of(context).size.width,
                          duration: Duration(milliseconds: 300),
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
              'Transaction Daily Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categoryPercentages.length,
                itemBuilder: (context, index) {
                  final categoryName =
                      categoryPercentages.keys.elementAt(index);
                  final percentage = categoryPercentages[categoryName]!;
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
        return Colors.yellow;
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
