import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:triggerly/app/models/meal_analysis.dart';
import 'package:triggerly/app/providers/meal_history_provider.dart';

class SummaryPage extends ConsumerStatefulWidget {
  const SummaryPage({super.key});

  @override
  ConsumerState<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends ConsumerState<SummaryPage> {
  bool _isTriggeringMealsExpanded = true;
  bool _isRefluxTriggersExpanded = true;

  @override
  Widget build(BuildContext context) {
    final mealHistory = ref.watch(mealHistoryProvider);
    final theme = Theme.of(context);

    // Extract all reflux triggers from meal history and flatten into a single list
    final Map<String, RefluxTrigger> uniqueRefluxTriggers = {};
    final List<Map<String, dynamic>> triggeringMeals = [];

    for (final meal in mealHistory) {
      final analysis = MealAnalysis.fromMap(meal);
      if (analysis.refluxTriggers != null &&
          analysis.refluxTriggers!.isNotEmpty) {
        // Only keep the latest occurrence of each trigger
        for (final trigger in analysis.refluxTriggers!) {
          if (trigger.trigger != null) {
            uniqueRefluxTriggers[trigger.trigger!] = trigger;
          }
        }
        triggeringMeals.add(meal);
      }
    }

    // Convert the map values back to a list
    final allRefluxTriggers = uniqueRefluxTriggers.values.toList();

    // Sort triggering meals by date and take the 5 most recent
    triggeringMeals.sort(
      (a, b) => DateTime.parse(
        b['created_at'],
      ).compareTo(DateTime.parse(a['created_at'])),
    );
    final recentTriggeringMeals = triggeringMeals.take(5).toList();

    return allRefluxTriggers.isEmpty
        ? const Center(child: IntroductionWidget())
        : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const IntroductionWidget(),
                if (recentTriggeringMeals.isNotEmpty)
                  Card(
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    child: ExpansionTile(
                      shape: const Border(),
                      initiallyExpanded: _isTriggeringMealsExpanded,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          _isTriggeringMealsExpanded = expanded;
                        });
                      },
                      leading: Icon(
                        Icons.restaurant,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        'Recent Triggering Meals',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recentTriggeringMeals.length,
                          itemBuilder: (context, index) {
                            final meal = recentTriggeringMeals[index];
                            final analysis = MealAnalysis.fromMap(meal);
                            final date =
                                meal['created_at'] != null
                                    ? DateFormat(
                                      'MMMM d, yyyy h:mm a',
                                    ).format(DateTime.parse(meal['created_at']))
                                    : 'No date';
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 4.0,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      analysis.mealName ?? 'Unknown Meal',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      date,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withAlpha(179),
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${analysis.refluxTriggers?.length ?? 0} triggers',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.error,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                Card(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: ExpansionTile(
                    shape: const Border(),
                    initiallyExpanded: _isRefluxTriggersExpanded,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _isRefluxTriggersExpanded = expanded;
                      });
                    },
                    leading: Icon(
                      Icons.warning_amber_rounded,
                      color: theme.colorScheme.error,
                    ),
                    title: Text(
                      'Reflux Triggers',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: allRefluxTriggers.length,
                        itemBuilder: (context, index) {
                          final trigger = allRefluxTriggers[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 4.0,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: theme.colorScheme.error,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          trigger.trigger ?? 'Unknown Trigger',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (trigger.info != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      trigger.info!,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withAlpha(179),
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
  }
}

class IntroductionWidget extends ConsumerWidget {
  const IntroductionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Track and analyze your meals to identify reflux triggers',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(179),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () {
            ref.read(selectedMealProvider.notifier).state = null;
            context.push('/analyzer');
          },
          icon: const Icon(Icons.add),
          label: const Text('Add New Meal'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
