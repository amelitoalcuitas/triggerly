import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:triggerly/app/models/meal_analysis.dart';
import 'package:triggerly/app/providers/meal_history_provider.dart';
import 'package:triggerly/app/shared/widgets/empty_state_widget.dart';

class ChartsPage extends ConsumerWidget {
  const ChartsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealHistory = ref.watch(mealHistoryProvider);

    // Filter meals where user_triggered is true and collect reflux triggers
    final Map<String, int> triggerCounts = {};
    for (final meal in mealHistory) {
      if (meal['user_triggered'] == 1) {
        final analysis = MealAnalysis.fromMap(meal);
        print('analysis: ${analysis.toJson()}');
        if (analysis.refluxTriggers != null) {
          for (final trigger in analysis.refluxTriggers!) {
            print('trigger: $trigger');
            if (trigger.trigger != null) {
              triggerCounts[trigger.trigger!] =
                  (triggerCounts[trigger.trigger!] ?? 0) + 1;
            }
          }
        }
      }
    }

    // Convert to pie chart data
    final List<PieChartSectionData> sections = [];
    int index = 0;
    triggerCounts.forEach((trigger, count) {
      sections.add(
        PieChartSectionData(
          value: count.toDouble(),
          title: '$trigger\n($count)',
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          color: Colors.primaries[index % Colors.primaries.length],
        ),
      );
      index++;
    });

    print('triggerCounts: $triggerCounts');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child:
                triggerCounts.isEmpty
                    ? const EmptyStateWidget(
                      title: 'No Reflux Triggers Found',
                      subtitle:
                          'No meals that triggered reflux have been recorded yet. Start tracking your meals to see your reflux triggers.',
                      icon: Icons.pie_chart_outline,
                    )
                    : PieChart(
                      PieChartData(
                        sections: sections,
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        startDegreeOffset: -90,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
