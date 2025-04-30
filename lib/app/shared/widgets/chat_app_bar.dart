import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/meal_history_provider.dart';

class ChatAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMeal = ref.watch(selectedMealProvider);

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => context.pop(),
      ),
      title: Text('Meal Analyzer'),
      actions: [
        if (selectedMeal != null)
          IconButton(
            icon: Icon(
              Icons.delete_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Delete Meal Analysis'),
                      content: const Text(
                        'Are you sure you want to delete this meal analysis? This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
              );

              if (shouldDelete == true && context.mounted) {
                await ref
                    .read(mealHistoryProvider.notifier)
                    .deleteMealHistory(selectedMeal['id']);
                ref.read(selectedMealProvider.notifier).state = null;
                if (context.mounted) {
                  context.pop();
                }
              }
            },
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Theme.of(context).dividerColor, height: 0.25),
      ),
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
