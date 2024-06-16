import 'package:expense_tracker_app/entities/income_entity.dart';
import 'package:expense_tracker_app/models/incometype.dart';

class Income {
  String incomeId;
  IncomeType incomeType;
  DateTime date;
  int amount;

  Income({
    required this.incomeId,
    required this.incomeType,
    required this.date,
    required this.amount,
  });

  static final empty = Income(
    incomeId: '',
    incomeType: IncomeType.empty,
    date: DateTime.now(),
    amount: 0,
  );

  IncomeEntity toEntity() {
    return IncomeEntity(
      incomeId: incomeId,
      incomeType: incomeType,
      date: date,
      amount: amount,
    );
  }

  static Income fromEntity(IncomeEntity entity) {
    return Income(
      incomeId: entity.incomeId,
      incomeType: entity.incomeType,
      date: entity.date,
      amount: entity.amount,
    );
  }

  // @override
  // String toString() {
  //   return 'Expense: {category: $category, amount: $amount, date: $date}';
  // }
}
