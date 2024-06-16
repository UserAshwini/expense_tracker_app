import 'package:expense_tracker_app/screens/add/views/add_expense.dart';
import 'package:expense_tracker_app/screens/add/views/add_income.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ToggleSwitch(
                minWidth: 120.0,
                initialLabelIndex: currentIndex,
                radiusStyle: true,
                cornerRadius: 20.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: const ['Add Income', 'Add Expense'],
                activeBgColors: [
                  [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                  [
                    Theme.of(context).colorScheme.tertiary,
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.primary,
                  ],
                ],
                onToggle: (index) {
                  setState(() {
                    currentIndex = index!;
                  });
                  print('switched to: $index');
                },
              ),
            ),
          ),
          Expanded(
              child: IndexedStack(
            index: currentIndex,
            children: [
              AddIncomeScreen(),
              AddExpenseScreen(),
            ],
          ))
        ],
      )),
    );
  }
}
