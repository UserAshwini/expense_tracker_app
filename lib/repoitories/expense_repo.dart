import 'package:expense_tracker_app/models/caregory.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/models/income.dart';
import 'package:expense_tracker_app/models/incometype.dart';

abstract class ExpenseRepository {
  Future<void> createCategory(Category category);

  Future<List<Category>> getCategory();

  Future<void> createExpense(Expense expense);

  Future<List<Expense>> getExpenses();

  Future<void> createIncomeType(IncomeType incometype);

  Future<List<IncomeType>> getIncomeType();

  Future<void> createIncome(Income income);

  Future<List<Income>> getIncome();
}
