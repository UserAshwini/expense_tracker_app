import 'dart:math';

import 'package:expense_tracker_app/bloc/create_categories/create_category_bloc.dart';
import 'package:expense_tracker_app/bloc/create_expense/create_expense_bloc.dart';
import 'package:expense_tracker_app/bloc/create_income/create_income_bloc.dart';
import 'package:expense_tracker_app/bloc/create_incometype/create_incometype_bloc.dart';
import 'package:expense_tracker_app/bloc/get_categories/get_category_bloc.dart';
import 'package:expense_tracker_app/bloc/get_categories/get_category_event.dart';
import 'package:expense_tracker_app/bloc/get_expense/get_expense_bloc.dart';
import 'package:expense_tracker_app/bloc/get_expense/get_expense_event.dart';
import 'package:expense_tracker_app/bloc/get_expense/get_expense_state.dart';
import 'package:expense_tracker_app/bloc/get_income/get_income_bloc.dart';
import 'package:expense_tracker_app/bloc/get_incometype/get_incometype_bloc.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/models/income.dart';
import 'package:expense_tracker_app/repoitories/firebase_expense_repo.dart';
import 'package:expense_tracker_app/screens/add/views/add_screen.dart';
import 'package:expense_tracker_app/screens/home/views/main_screen.dart';
import 'package:expense_tracker_app/screens/stats/views/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  late Color selectedItem = Theme.of(context).colorScheme.primary;
  Color unselectedItem = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetIncomeBloc, GetIncomeState>(
      builder: (context, incomeState) {
        print("6");
        return BlocBuilder<GetExpensesBloc, GetExpensesState>(
            builder: (context, expenseState) {
          print("7");
          if (expenseState is GetExpensesSuccess &&
              incomeState is GetIncomeSuccess) {
            print("8");
            print({"results1234": incomeState.income});
            return Scaffold(
                bottomNavigationBar: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
                  child: BottomNavigationBar(
                      onTap: (value) {
                        setState(() {
                          index = value;
                        });
                      },
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      elevation: 3,
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.home,
                                color:
                                    index == 0 ? selectedItem : unselectedItem),
                            label: 'Home'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.graphic_eq_rounded,
                                color:
                                    index == 1 ? selectedItem : unselectedItem),
                            label: 'Stats')
                      ]),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                                create: (context) =>
                                    CreateCategoryBloc(FirebaseExpenseRepo())),
                            BlocProvider(
                                create: (context) =>
                                    GetCategoriesBloc(FirebaseExpenseRepo())
                                      ..add(GetCategories())),
                            BlocProvider(
                                create: (context) =>
                                    CreateExpenseBloc(FirebaseExpenseRepo())),
                            BlocProvider(
                                create: (context) => CreateIncometypeBloc(
                                    FirebaseExpenseRepo())),
                            BlocProvider(
                                create: (context) =>
                                    GetIncometypeBloc(FirebaseExpenseRepo())
                                      ..add(GetIncometype())),
                            BlocProvider(
                                create: (context) =>
                                    CreateIncomeBloc(FirebaseExpenseRepo())),
                          ],
                          child: const AddScreen(),
                        ),
                      ),
                    );
                    print("1");
                    if (result is Income) {
                      print("2");
                      context.read<GetIncomeBloc>().add(GetIncome());
                      print("3");
                    } else if (result is Expense) {
                      print("4");
                      context.read<GetExpensesBloc>().add(GetExpenses());
                      print("5");
                    }
                    // print({"resultsincfexp": incomeState.income});
                    // print({"results321": expenseState.expenses});

                    // if (result is Expense) {
                    //   print({"resultsbfexp": result});
                    //   setState(() {
                    //     localExpenses.insert(0, result);
                    //   });
                    // } else if (result is Income) {
                    //   print({"resultsbfin": incomeState.income});
                    //   setState(() {
                    //     localIncome.insert(0, result);
                    //   });
                    //   print({"resultsaginc": incomeState.income});
                    // }
                  },
                  shape: const CircleBorder(),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.tertiary,
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.primary,
                          ],
                          transform: const GradientRotation(pi / 4),
                        )),
                    child: const Icon(Icons.add),
                  ),
                ),
                body: index == 0
                    ? MainScreen(
                        income: incomeState.income,
                        expenses: expenseState.expenses,
                      )
                    : const StatsScreen());
          } else {
            print("9");
            return const Scaffold(
              body: Center(
                child: Text("data"),
              ),
            );
          }
        });
      },
    );
  }
}
