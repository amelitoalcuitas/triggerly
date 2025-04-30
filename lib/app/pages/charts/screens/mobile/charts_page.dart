import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:triggerly/app/models/meal_analysis.dart';
import 'package:triggerly/app/providers/meal_history_provider.dart';
import 'package:triggerly/app/shared/widgets/empty_state_widget.dart';

class ChartsPage extends ConsumerWidget {
  const ChartsPage({super.key});

  /// Helper method to format long text into multiple lines with max 12 chars per line
  String _formatTextToMultiLine(String text) {
    final words = text.split(' ');
    String formattedText = '';
    String currentLine = '';

    for (final word in words) {
      if (currentLine.isEmpty) {
        currentLine = word;
      } else if ('$currentLine $word'.length <= 12) {
        currentLine = '$currentLine $word';
      } else {
        formattedText += '$currentLine\n';
        currentLine = word;
      }
    }
    formattedText += currentLine;
    return formattedText;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealHistory = ref.watch(mealHistoryProvider);

    // Filter meals where user_triggered is true and collect reflux triggers
    final Map<String, int> triggerCounts = {};
    final Map<String, int> mealTriggers = {};
    final Map<String, int> dailyTriggerCounts = {};

    for (final meal in mealHistory) {
      if (meal['user_triggered'] == 1) {
        final analysis = MealAnalysis.fromMap(meal);
        final date = DateTime.parse(meal['created_at']);
        final dateStr =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        // Count daily triggers
        dailyTriggerCounts[dateStr] = (dailyTriggerCounts[dateStr] ?? 0) + 1;

        if (analysis.refluxTriggers != null) {
          for (final trigger in analysis.refluxTriggers!) {
            if (trigger.trigger != null) {
              triggerCounts[trigger.trigger!] =
                  (triggerCounts[trigger.trigger!] ?? 0) + 1;
            }
          }
        }

        // Populate mealTriggers
        if (analysis.mealName != null) {
          mealTriggers[analysis.mealName!] =
              (mealTriggers[analysis.mealName!] ?? 0) + 1;
        }
      }
    }

    // Convert to pie chart data
    final List<PieChartSectionData> sections = [];
    int index = 0;
    triggerCounts.forEach((trigger, count) {
      // Format trigger title into multiple lines
      final formattedTitle = _formatTextToMultiLine(trigger);

      sections.add(
        PieChartSectionData(
          value: count.toDouble(),
          title: '$formattedTitle\n($count)',
          radius: 100,
          titleStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          color: Colors.primaries[index % Colors.primaries.length],
          titlePositionPercentageOffset: 0.5,
        ),
      );
      index++;
    });

    final List<PieChartSectionData> mealSections = [];
    mealTriggers.forEach((meal, count) {
      // Format meal name into multiple lines
      final formattedMeal = _formatTextToMultiLine(meal);

      mealSections.add(
        PieChartSectionData(
          value: count.toDouble(),
          title: '$formattedMeal\n($count)',
          radius: 100,
          titleStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          color: Colors.primaries[index % Colors.primaries.length],
          titlePositionPercentageOffset: 0.5,
        ),
      );
      index++;
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          children: [
            if (triggerCounts.isEmpty &&
                mealTriggers.isEmpty &&
                dailyTriggerCounts.isEmpty) ...[
              const EmptyStateWidget(
                title: 'No Data Available',
                subtitle:
                    'No meal triggers have been recorded yet. Start tracking your meals to see your trigger patterns.',
                icon: Icons.bar_chart,
              ),
            ] else ...[
              if (triggerCounts.isNotEmpty) ...[
                const Text(
                  'Reflux Triggers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      startDegreeOffset: -90,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              if (mealTriggers.isNotEmpty) ...[
                const Text(
                  'Meal Triggers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sections: mealSections,
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      startDegreeOffset: -90,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              if (dailyTriggerCounts.isNotEmpty) ...[
                const Text(
                  'Daily Trigger Count',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barGroups:
                          dailyTriggerCounts.entries.map((entry) {
                            return BarChartGroupData(
                              x:
                                  DateTime.parse(
                                    entry.key,
                                  ).millisecondsSinceEpoch,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.toDouble(),
                                  color: Colors.blue,
                                  width: 16,
                                ),
                              ],
                            );
                          }).toList(),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,
                            getTitlesWidget:
                                (value, meta) => Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 11),
                                ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              final date = DateTime.fromMillisecondsSinceEpoch(
                                value.toInt(),
                              );
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  '${date.month}/${date.day}',
                                  style: const TextStyle(fontSize: 11),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
