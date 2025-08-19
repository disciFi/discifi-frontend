import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rmw/core/api/api_provider.dart';
import 'package:rmw/core/models/transaction.dart';

final transactionsProvider = FutureProvider<List<Transaction>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getTransactions();
});
