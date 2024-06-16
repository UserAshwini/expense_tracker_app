class IncomeTypeEntity {
  String incomeTypeId;
  String name;
  int totalExpenses;
  String icon;
  int color;

  IncomeTypeEntity({
    required this.incomeTypeId,
    required this.name,
    required this.totalExpenses,
    required this.icon,
    required this.color,
  });

  Map<String, Object?> toDocument() {
    return {
      'incomeTypeId': incomeTypeId,
      'name': name,
      'totalExpenses': totalExpenses,
      'icon': icon,
      'color': color,
    };
  }

  static IncomeTypeEntity fromDocument(Map<String, dynamic> doc) {
    return IncomeTypeEntity(
      incomeTypeId: doc['incomeTypeId'],
      name: doc['name'],
      totalExpenses: doc['totalExpenses'],
      icon: doc['icon'],
      color: doc['color'],
    );
  }
}
