enum InsightType { DAILY, WEEKLY, MONTHLY, UNKNOWN }

class Insight {
  final int id;
  final String content;
  final DateTime generatedAt;
  final InsightType type;

  Insight({
    required this.id,
    required this.content,
    required this.generatedAt,
    required this.type,
  });

  factory Insight.fromJson(Map<String, dynamic> json) {
    InsightType typeFromString(String? typeStr) {
      switch (typeStr) {
        case 'DAILY':
          return InsightType.DAILY;
        case 'WEEKLY':
          return InsightType.WEEKLY;
        case 'MONTHLY':
          return InsightType.MONTHLY;
        default:
          return InsightType.UNKNOWN;
      }
    }

    return Insight(
      id: json['id'],
      content: json['content'],
      generatedAt: DateTime.parse(json['generatedAt']),
      type: typeFromString(json['type']),
    );
  }
}
