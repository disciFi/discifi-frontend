import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rmw/features/insights/insights_provider.dart';
import 'package:rmw/shared/utils/app_theme.dart';
import 'package:rmw/core/models/insight.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsyncValue = ref.watch(insightsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights', style: TextStyle(color: AppTheme.primaryTextColor)),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: insightsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (insights) {
          if (insights.isEmpty) {
            return const Center(child: Text("No insights have been generated yet."));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: insights.length,
            itemBuilder: (context, index) {
              final insight = insights[index];
              return _buildInsightCard(insight);
            },
          );
        },
      ),
    );
  }

  Widget _buildInsightCard(Insight insight) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getIconForType(insight.type), color: AppTheme.accentColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  _getTitleForType(insight.type),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryTextColor),
                ),
                const Spacer(),
                Text(
                  DateFormat.yMMMd().format(insight.generatedAt),
                  style: const TextStyle(fontSize: 12, color: AppTheme.secondaryTextColor),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              insight.content,
              style: const TextStyle(fontSize: 16, color: AppTheme.primaryTextColor, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitleForType(InsightType type) {
    switch (type) {
      case InsightType.DAILY: return 'Daily Summary';
      case InsightType.WEEKLY: return 'Weekly Review';
      case InsightType.MONTHLY: return 'Monthly Report';
      default: return 'Insight';
    }
  }

  IconData _getIconForType(InsightType type) {
    switch (type) {
      case InsightType.DAILY: return Icons.today;
      case InsightType.WEEKLY: return Icons.calendar_view_week;
      case InsightType.MONTHLY: return Icons.calendar_month;
      default: return Icons.lightbulb_outline;
    }
  }
}