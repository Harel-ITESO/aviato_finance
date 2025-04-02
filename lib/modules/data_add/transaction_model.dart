class TransactionData {
  final String name;
  final double amount;
  final DateTime date;
  final String category;
  final String paymentMethod;
  final String repeat;
  final String description;
  final bool isIncome;

  TransactionData({
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
    required this.paymentMethod,
    required this.repeat,
    required this.description,
    required this.isIncome,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": isIncome ? 'Income' : 'Outcome',
      "name": name,
      "amount": amount,
      "date": date.toIso8601String(),
      "category": category,
      "paymentMethod": paymentMethod,
      "repeat": repeat,
      "description": description,
    };
  }
}