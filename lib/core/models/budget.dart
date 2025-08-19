class Budget {
  final int id;
  final String period;
  final String categoryName;
  final double budgetAmount;
  final double amountSpent;
  final double amountRemaining;

  Budget({
    required this.id,
    required this.period,
    required this.categoryName,
    required this.budgetAmount,
    required this.amountSpent,
    required this.amountRemaining,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      period: json['period'],
      categoryName: json['categoryName'],
      budgetAmount: (json['budgetAmount'] as num).toDouble(),
      amountSpent: (json['amountSpent'] as num).toDouble(),
      amountRemaining: (json['amountRemaining'] as num).toDouble(),
    );
  }
}