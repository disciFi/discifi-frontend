class Account {
  final int id;
  final String name;
  final String type;
  final double balance;
  final String currency;
  final bool active;

  Account({
    required this.id, 
    required this.name, 
    required this.currency,
    required this.balance,
    required this.type,
    required this.active
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      currency: json['currency'],
      type: json['type'],
      balance: (json['balance'] as num).toDouble(),
      active: json['active'] ?? true,
    );
  }
}
