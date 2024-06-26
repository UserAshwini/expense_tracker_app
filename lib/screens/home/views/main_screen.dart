import 'dart:math';

import 'package:expense_tracker_app/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/models/income.dart';
import 'package:expense_tracker_app/models/transaction.dart';
import 'package:expense_tracker_app/screens/authentications/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  final List<Expense> expenses;
  final List<Income> income;
  // final double totalIncome;
  const MainScreen(
      {super.key,
      required this.expenses,
      // required this.totalIncome,
      required this.income});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String filter = 'View All';

  double getTotalExpenses() {
    return widget.expenses.fold(0, (sum, item) => sum + item.amount);
  }

  double getTotalIncome() {
    return widget.income.fold(0, (sum, item) => sum + item.amount);
  }

  double getTotalBalance() {
    return getTotalIncome() - getTotalExpenses();
  }

  @override
  Widget build(BuildContext context) {
    double totalExpenses = getTotalExpenses();
    double totalIncome = getTotalIncome();
    double totalBalance = getTotalBalance();
    List<Transaction> transactions =
        getTransactions(widget.expenses, widget.income);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xff4E8397)),
                    ),
                    Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.outline,
                      size: 30,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      Text(
                        'Ashwini!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton<int>(
                    icon: const Icon(Icons.settings),
                    onSelected: (int result) {
                      // Handle the selected option
                      switch (result) {
                        case 0:
                          print('Log Out');
                          break;
                        // Add more cases as needed
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<int>>[
                      PopupMenuItem<int>(
                        value: 0,
                        child: GestureDetector(
                          child: const Text('Log Out'),
                          onTap: () =>
                              BlocProvider.of<AuthenticationBloc>(context).add(
                            AuthenticationExited(),
                          ),
                        ),
                      ),
                      // Add more PopupMenuItems as needed
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.tertiary,
                    ],
                    transform: const GradientRotation(pi / 4),
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 4,
                        color: Colors.grey.shade300,
                        offset: const Offset(5, 5))
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                  Text(
                    '₹ ${totalBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 38,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                  color: Colors.white30,
                                  shape: BoxShape.circle),
                              child: const Center(
                                  child: Icon(
                                Icons.arrow_downward_outlined,
                                size: 14,
                                color: Color.fromARGB(255, 22, 167, 27),
                              )),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Income',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                                Text(
                                  '₹ ${totalIncome.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                  color: Colors.white30,
                                  shape: BoxShape.circle),
                              child: const Center(
                                  child: Icon(
                                Icons.arrow_upward,
                                size: 14,
                                color: Colors.red,
                              )),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Expenses',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                                Text(
                                  '-₹ ${totalExpenses.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                DropdownButton<String>(
                  value: filter,
                  icon: const Icon(Icons.filter_list),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      filter = newValue!;
                    });
                  },
                  items: <String>['View All', 'Expense', 'Income']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (BuildContext context, int i) {
                  Transaction transaction = transactions[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Color(transaction.color),
                                      shape: BoxShape.circle),
                                ),
                                transaction.type == 'expense'
                                    ? Image.asset(
                                        'assets/expenses/${transaction.icon}.png',
                                        scale: 2,
                                        color: Colors.white,
                                      )
                                    : Image.asset(
                                        'assets/income/${transaction.icon}.png',
                                        scale: 8,
                                        color: Colors.white,
                                      )
                              ],
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Text(
                                transaction.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  transaction.type == 'expense'
                                      ? "-₹${transaction.amount.toString()}"
                                      : "+₹${transaction.amount.toString()}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                                Text(
                                  DateFormat("dd/MM/yyyy")
                                      .format(transaction.date),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Transaction> getTransactions(
      List<Expense> expenses, List<Income> income) {
    List<Transaction> transactions = [];

    for (var expense in expenses) {
      transactions.add(Transaction(
        amount: expense.amount,
        date: expense.date,
        name: expense.category.name,
        type: 'expense',
        color: expense.category.color,
        icon: expense.category.icon,
      ));
    }

    for (var inc in income) {
      transactions.add(Transaction(
        amount: inc.amount,
        date: inc.date,
        name: inc.incomeType.name,
        type: 'income',
        color: inc.incomeType.color,
        icon: inc.incomeType.icon,
      ));
    }

    transactions.sort((a, b) => b.date.compareTo(a.date));
    if (filter == 'Expense') {
      return transactions
          .where((transaction) => transaction.type == 'expense')
          .toList();
    } else if (filter == 'Income') {
      return transactions
          .where((transaction) => transaction.type == 'income')
          .toList();
    } else {
      return transactions;
    }
  }
}
