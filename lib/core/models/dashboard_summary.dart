class DashboardSummary {
  final double todaySpend;
  final double thisWeekSpend;
  final double thisMonthSpend;
  final double previousDaySpend;
  final double previousWeekSpend;
  final double previousMonthSpend;

  DashboardSummary({
    required this.todaySpend,
    required this.thisWeekSpend,
    required this.thisMonthSpend,
    required this.previousDaySpend,
    required this.previousWeekSpend,
    required this.previousMonthSpend,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      todaySpend: (json['todaySpend'] as num).toDouble(),
      thisWeekSpend: (json['thisWeekSpend'] as num).toDouble(),
      thisMonthSpend: (json['thisMonthSpend'] as num).toDouble(),
      previousDaySpend: (json['previousDaySpend'] as num).toDouble(),
      previousWeekSpend: (json['previousWeekSpend'] as num).toDouble(),
      previousMonthSpend: (json['previousMonthSpend'] as num).toDouble(),
    );
  }
}