import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rmw/core/models/budget.dart';
import 'package:rmw/core/api/api_provider.dart';
import 'package:intl/intl.dart';

final budgetsProvider = FutureProvider<List<Budget>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final currentPeriod = DateFormat('yyyy-MM').format(DateTime.now());
  return apiService.getBudgets(currentPeriod);
});