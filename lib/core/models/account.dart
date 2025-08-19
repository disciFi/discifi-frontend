class Account {
  final int id;
  final String name;
  final String currency;

  Account({required this.id, required this.name, required this.currency});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      currency: json['currency'],
    );
  }
}