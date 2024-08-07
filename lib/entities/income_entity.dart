import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/entities/incometype_entity.dart';
import 'package:expense_tracker_app/models/incometype.dart';

class IncomeEntity {
  String incomeId;
  IncomeType incomeType;
  DateTime date;
  int amount;
  String userId;

  IncomeEntity(
      {required this.incomeId,
      required this.incomeType,
      required this.date,
      required this.amount,
      required this.userId});

  Map<String, Object?> toDocument() {
    return {
      'incomeId': incomeId,
      'incomeType': incomeType.toEntity().toDocument(),
      'date': date,
      'amount': amount,
      'userId': userId
    };
  }

  static IncomeEntity fromDocument(Map<String, dynamic> doc) {
    return IncomeEntity(
      incomeId: doc['incomeId'],
      incomeType: IncomeType.fromEntity(
          IncomeTypeEntity.fromDocument(doc['incomeType'])),
      date: (doc['date'] as Timestamp).toDate(),
      amount: doc['amount'],
      userId: doc['userId'],
    );
  }
}
