import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triggerly/app/models/meal_analysis.dart';

class MealFeedbackWidget extends ConsumerWidget {
  final MealAnalysis? currentAnalysis;
  final Function(bool) onUpdateUserTriggered;

  const MealFeedbackWidget({
    super.key,
    required this.currentAnalysis,
    required this.onUpdateUserTriggered,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(60),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Did this meal trigger your acid reflux symptoms?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(width: 8),
          Row(
            children: [
              IconButton(
                onPressed: () => onUpdateUserTriggered(false),
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => onUpdateUserTriggered(true),
                icon: const Icon(Icons.check_rounded, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
