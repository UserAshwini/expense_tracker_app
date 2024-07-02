import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/entities/category_entity.dart';
import 'package:expense_tracker_app/entities/expense_entity.dart';
import 'package:expense_tracker_app/entities/income_entity.dart';
import 'package:expense_tracker_app/entities/incometype_entity.dart';
import 'package:expense_tracker_app/models/caregory.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/models/income.dart';
import 'package:expense_tracker_app/models/incometype.dart';
import 'package:expense_tracker_app/repoitories/expense_repo.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createEmptyCategories(String userId, Category category) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(category.categoryId)
          .set(category.toEntity().toDocument());
    } catch (e) {
      print("Error creating empty categories: $e");
      rethrow;
    }
  }

  @override
  Future<void> createEmptyExpenses(String userId, Expense expense) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(expense.expenseId)
          .set(expense.toEntity().toDocument());
    } catch (e) {
      print("Error creating empty expenses: $e");
      rethrow;
    }
  }

  @override
  Future<void> createEmptyIncomeTypes(
      String userId, IncomeType incometype) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('incomeTypes')
          .doc(incometype.incomeTypeId)
          .set(incometype.toEntity().toDocument());
    } catch (e) {
      print("Error creating empty income types: $e");
      rethrow;
    }
  }

  @override
  Future<void> createEmptyIncomes(String userId, Income income) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('incomes')
          .doc(income.incomeId)
          .set(income.toEntity().toDocument());
    } catch (e) {
      print("Error creating empty incomes: $e");
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategories(String userId) async {
    try {
      var snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      List<Category> categories = snapshot.docs
          .map((category) =>
              Category.fromEntity(CategoryEntity.fromDocument(category.data())))
          .toList();

      return categories;
    } catch (e) {
      print("Error getting categories: $e");
      rethrow;
    }
  }

  @override
  Future<List<Expense>> getExpenses(String userId) async {
    try {
      var snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      List<Expense> expenses = snapshot.docs
          .map((expense) =>
              Expense.fromEntity(ExpenseEntity.fromDocument(expense.data())))
          .toList();

      return expenses;
    } catch (e) {
      print("Error getting expenses: $e");
      rethrow;
    }
  }

  @override
  Future<List<IncomeType>> getIncomeTypes(String userId) async {
    try {
      var snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('incomeTypes')
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      List<IncomeType> incomeTypes = snapshot.docs
          .map((incomeType) => IncomeType.fromEntity(
              IncomeTypeEntity.fromDocument(incomeType.data())))
          .toList();

      return incomeTypes;
    } catch (e) {
      print("Error getting income types: $e");
      rethrow;
    }
  }

  @override
  Future<List<Income>> getIncomes(String userId) async {
    try {
      var snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('incomes')
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      List<Income> incomes = snapshot.docs
          .map((income) =>
              Income.fromEntity(IncomeEntity.fromDocument(income.data())))
          .toList();

      return incomes;
    } catch (e) {
      print("Error getting incomes: $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteCategory(String categoryId, String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('categories')
          .doc(categoryId)
          .delete();
    } catch (e) {
      print("Error deleting category: $e");
      rethrow;
    }
  }

  @override
  Future<void> updateCategory(Category category, String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('categories')
          .doc(category.categoryId)
          .update(category.toEntity().toDocument());
    } catch (e) {
      print("Error updating category: $e");
      rethrow;
    }
  }
}
