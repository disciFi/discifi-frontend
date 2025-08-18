import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_provider.dart';
import '../../core/models/dashboard_summary.dart';

final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getDashboardSummary();
});