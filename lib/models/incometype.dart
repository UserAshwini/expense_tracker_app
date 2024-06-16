import 'package:expense_tracker_app/entities/incometype_entity.dart';

class IncomeType {
  String incomeTypeId;
  String name;
  int totalExpenses;
  String icon;
  int color;

  IncomeType({
    required this.incomeTypeId,
    required this.name,
    required this.totalExpenses,
    required this.icon,
    required this.color,
  });

  static final empty = IncomeType(
    incomeTypeId: '',
    name: '',
    totalExpenses: 0,
    icon: '',
    color: 0,
  );

  IncomeTypeEntity toEntity() {
    return IncomeTypeEntity(
      incomeTypeId: incomeTypeId,
      name: name,
      totalExpenses: totalExpenses,
      icon: icon,
      color: color,
    );
  }

  static IncomeType fromEntity(IncomeTypeEntity entity) {
    return IncomeType(
      incomeTypeId: entity.incomeTypeId,
      name: entity.name,
      totalExpenses: entity.totalExpenses,
      icon: entity.icon,
      color: entity.color,
    );
  }

  // @override
  // String toString() {
  //   return 'IncomeType: {name: $name}';
  // }
}
