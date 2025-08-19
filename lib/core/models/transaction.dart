import 'account.dart';
import 'category.dart';

class Transaction {
  final int id;
  final String title;
  final double amount;
  final String type;
  final DateTime date;
  final Account account;
  final Category category;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.account,
    required this.category,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'],
      date: DateTime.parse(json['date']),
      account: Account.fromJson(json['account']),
      category: Category.fromJson(json['category']),
    );
  }
}