import 'package:expense_tracker_app/bloc/get_expense/get_expense_bloc.dart';
import 'package:expense_tracker_app/bloc/get_expense/get_expense_event.dart';
import 'package:expense_tracker_app/bloc/get_income/get_income_bloc.dart';
import 'package:expense_tracker_app/repoitories/firebase_expense_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/home/views/home_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Expense Tracker",
      theme: ThemeData(
        colorScheme: ColorScheme.light(
            background: Colors.grey.shade100,
            onBackground: Colors.black,
            primary: const Color(0xffFF8066),
            secondary: const Color(0xffC34A36),
            tertiary: const Color(0xff4B4453),
            outline: Colors.grey.shade400),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<GetExpensesBloc>(
            create: (context) =>
                GetExpensesBloc(FirebaseExpenseRepo())..add(GetExpenses()),
          ),
          BlocProvider<GetIncomeBloc>(
            create: (context) =>
                GetIncomeBloc(FirebaseExpenseRepo())..add(GetIncome()),
          ),
        ],
        child: const HomeScreen(),
      ),
    );
  }
}
