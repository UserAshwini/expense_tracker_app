import 'package:expense_tracker_app/entities/incometype_entity.dart';

class IncomeType {
  String incomeTypeId;
  String name;
  int totalIncome;
  String icon;
  int color;
  String userId;

  IncomeType(
      {required this.incomeTypeId,
      required this.name,
      required this.totalIncome,
      required this.icon,
      required this.color,
      required this.userId});

  static final empty = IncomeType(
    incomeTypeId: '',
    name: '',
    totalIncome: 0,
    icon: '',
    color: 0,
    userId: '',
  );

  IncomeTypeEntity toEntity() {
    return IncomeTypeEntity(
      incomeTypeId: incomeTypeId,
      name: name,
      totalIncome: totalIncome,
      icon: icon,
      color: color,
      userId: userId,
    );
  }

  static IncomeType fromEntity(IncomeTypeEntity entity) {
    return IncomeType(
      incomeTypeId: entity.incomeTypeId,
      name: entity.name,
      totalIncome: entity.totalIncome,
      icon: entity.icon,
      color: entity.color,
      userId: entity.userId,
    );
  }

  // @override
  // String toString() {
  //   return 'IncomeType: {name: $name}';
  // }
}
