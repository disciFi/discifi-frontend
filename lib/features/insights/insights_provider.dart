import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rmw/core/api/api_provider.dart';
import 'package:rmw/core/models/insight.dart';

final insightsProvider = FutureProvider<List<Insight>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getInsights();
});
