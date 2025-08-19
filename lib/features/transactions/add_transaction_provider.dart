import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rmw/core/api/api_provider.dart';
import 'package:rmw/core/models/account.dart';
import 'package:rmw/core/models/category.dart';

final accountsProvider = FutureProvider<List<Account>>((ref) {
  return ref.watch(apiServiceProvider).getAccounts();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(apiServiceProvider).getCategories();
});
