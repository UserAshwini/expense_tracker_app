import 'package:expense_tracker_app/models/caregory.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/models/income.dart';
import 'package:expense_tracker_app/models/incometype.dart';

abstract class ExpenseRepository {
  Future<List<Category>> getCategories(String userId);

  Future<List<Expense>> getExpenses(String userId);

  Future<List<IncomeType>> getIncomeTypes(String userId);

  Future<List<Income>> getIncomes(String userId);

  Future<void> createEmptyCategories(String userId, Category category);

  Future<void> createEmptyExpenses(String userId, Expense expense);

  Future<void> createEmptyIncomeTypes(String userId, IncomeType incometype);

  Future<void> createEmptyIncomes(String userId, Income income);
  Future<void> updateCategory(Category category, String uid);
  Future<void> deleteCategory(String categoryId, String uid);
}
