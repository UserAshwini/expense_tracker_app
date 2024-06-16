import 'dart:developer';

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
  final categoryCollection =
      FirebaseFirestore.instance.collection('categories');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');
  final incometypeCollection =
      FirebaseFirestore.instance.collection('incometype');
  final incomeCollection = FirebaseFirestore.instance.collection('income');

  @override
  Future<void> createCategory(Category category) async {
    try {
      await categoryCollection
          .doc(category.categoryId)
          .set(category.toEntity().toDocument());
    } catch (e) {
      log("error create category $e");
      return;
    }
  }

  @override
  Future<List<Category>> getCategory() async {
    try {
      return await categoryCollection.get().then((value) => value.docs
          .map(
              (e) => Category.fromEntity(CategoryEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log("error get category $e");
      rethrow;
    }
  }

  @override
  Future<void> createExpense(Expense expense) async {
    try {
      await expenseCollection
          .doc(expense.expenseId)
          .set(expense.toEntity().toDocument());
    } catch (e) {
      log("error create expense $e");
      rethrow;
    }
  }

  @override
  Future<List<Expense>> getExpenses() async {
    try {
      return await expenseCollection.get().then((value) => value.docs
          .map((e) => Expense.fromEntity(ExpenseEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log("error get expense $e");
      rethrow;
    }
  }

  @override
  Future<void> createIncome(Income income) async {
    try {
      await incomeCollection
          .doc(income.incomeId)
          .set(income.toEntity().toDocument());
    } catch (e) {
      log("error create expense $e");
      rethrow;
    }
  }

  @override
  Future<void> createIncomeType(IncomeType incometype) async {
    try {
      await incometypeCollection
          .doc(incometype.incomeTypeId)
          .set(incometype.toEntity().toDocument());
    } catch (e) {
      log("error create incometype $e");
      return;
    }
  }

  @override
  Future<List<Income>> getIncome() async {
    try {
      return await incomeCollection.get().then((value) => value.docs
          .map((e) => Income.fromEntity(IncomeEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log("error get income $e");
      rethrow;
    }
  }

  @override
  Future<List<IncomeType>> getIncomeType() async {
    try {
      return await incometypeCollection.get().then((value) => value.docs
          .map((e) =>
              IncomeType.fromEntity(IncomeTypeEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log("error get incometype $e");
      rethrow;
    }
  }
}
