import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../providers/meal_history_provider.dart';
import '../../database/database_helper.dart';

class HistoryDrawer extends ConsumerWidget {
  const HistoryDrawer({super.key});

  Future<void> _updateMealTriggerStatus(
    WidgetRef ref,
    String mealId,
    bool triggered,
  ) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'meal_history',
      {'user_triggered': triggered ? 1 : 0},
      where: 'id = ?',
      whereArgs: [mealId],
    );
    await ref.read(mealHistoryProvider.notifier).loadMealHistory();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealHistory = ref.watch(mealHistoryProvider);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('History', style: TextStyle(fontSize: 24)),
                  IconButton(
                    icon: const Icon(Icons.add_rounded),
                    onPressed: () {
                      ref.read(selectedMealProvider.notifier).state = null;
                      Navigator.pop(context);
                      context.push('/analyzer');
                    },
                  ),
                ],
              ),
            ),
            if (mealHistory.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No meal history yet'),
              )
            else
              ...mealHistory.map((meal) {
                final createdAt = DateTime.parse(meal['created_at']);
                final formattedDate =
                    '${createdAt.month}/${createdAt.day}/${createdAt.year} - ${createdAt.hour > 12 ? createdAt.hour - 12 : createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')} ${createdAt.hour >= 12 ? 'PM' : 'AM'}';

                final userTriggered = meal['user_triggered'];

                return Slidable(
                  enabled: userTriggered == null,
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed:
                            (context) => _updateMealTriggerStatus(
                              ref,
                              meal['id'].toString(),
                              false,
                            ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        icon: Icons.close_rounded,
                      ),
                      SlidableAction(
                        onPressed:
                            (context) => _updateMealTriggerStatus(
                              ref,
                              meal['id'].toString(),
                              true,
                            ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        icon: Icons.check_rounded,
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: Text(meal['meal_name'] ?? 'Unnamed Meal'),
                    subtitle: Text(formattedDate),
                    leading: Icon(
                      userTriggered == null
                          ? Icons.help_outline_rounded
                          : userTriggered == 1
                          ? Icons.mood_bad_rounded
                          : Icons.mood_rounded,
                      color:
                          userTriggered == null
                              ? Theme.of(context).colorScheme.onSurface
                              : userTriggered == 1
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                    ),
                    tileColor:
                        ref.watch(selectedMealProvider)?['id'] == meal['id']
                            ? Colors.grey.withAlpha(50)
                            : null,
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_rounded,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () {
                        final selectedMeal = ref.read(selectedMealProvider);
                        if (selectedMeal != null &&
                            selectedMeal['id'] == meal['id']) {
                          ref.read(selectedMealProvider.notifier).state = null;
                        }
                        ref
                            .read(mealHistoryProvider.notifier)
                            .deleteMealHistory(meal['id']);
                      },
                    ),
                    onTap: () async {
                      final mealFromDb = await ref
                          .read(mealHistoryProvider.notifier)
                          .getMealById(meal['id']);

                      if (!context.mounted) return;

                      if (mealFromDb != null) {
                        ref.read(selectedMealProvider.notifier).state =
                            mealFromDb;
                      }
                      Navigator.pop(context);
                      context.push('/analyzer');
                    },
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
