class Transaction {
  final int amount;
  final DateTime date;
  final String name;
  final String type;
  final int color;
  final String icon;

  Transaction({
    required this.amount,
    required this.date,
    required this.name,
    required this.type,
    required this.color,
    required this.icon,
  });
}
