class IncomeTypeEntity {
  String incomeTypeId;
  String name;
  int totalIncome;
  String icon;
  int color;
  String userId;

  IncomeTypeEntity(
      {required this.incomeTypeId,
      required this.name,
      required this.totalIncome,
      required this.icon,
      required this.color,
      required this.userId});

  Map<String, Object?> toDocument() {
    return {
      'incomeTypeId': incomeTypeId,
      'name': name,
      'totalIncome': totalIncome,
      'icon': icon,
      'color': color,
      'userId': userId
    };
  }

  static IncomeTypeEntity fromDocument(Map<String, dynamic> doc) {
    return IncomeTypeEntity(
      incomeTypeId: doc['incomeTypeId'],
      name: doc['name'],
      totalIncome: doc['totalIncome'],
      icon: doc['icon'],
      color: doc['color'],
      userId: doc['userId'],
    );
  }
}
