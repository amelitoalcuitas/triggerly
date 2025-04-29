import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triggerly/app/models/meal_analysis.dart';
import 'package:triggerly/app/providers/meal_history_provider.dart';

class MealAnalysisCard extends ConsumerWidget {
  final MealAnalysis mealAnalysis;
  final bool isImageExpanded;
  final VoidCallback onImageTap;

  const MealAnalysisCard({
    super.key,
    required this.mealAnalysis,
    required this.isImageExpanded,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMeal = ref.watch(selectedMealProvider);
    final analysis =
        selectedMeal != null
            ? MealAnalysis.fromMap(selectedMeal)
            : mealAnalysis;

    // Get the image to display
    final imageToShow =
        analysis.imagePath != null ? File(analysis.imagePath!) : null;

    return Column(
      children: [
        if (imageToShow != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onTap: onImageTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  child: SizedBox(
                    height: isImageExpanded ? null : 150,
                    width: double.infinity,
                    child: Image.file(imageToShow, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: Builder(
            builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    analysis.mealName ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    analysis.message ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (analysis.ingredients != null) ...[
                    const Text(
                      'Ingredients:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...analysis.ingredients?.map<Widget>(
                          (ingredient) => Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('• $ingredient'),
                          ),
                        ) ??
                        [],
                  ],
                  const SizedBox(height: 8),
                  if (analysis.refluxTriggers != null) ...[
                    const Text(
                      'Reflux Triggers:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (analysis.refluxTriggers!.isNotEmpty)
                      ...analysis.refluxTriggers!.map<Widget>(
                        (trigger) => Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RichText(
                            text: TextSpan(
                              text: '• ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: trigger.trigger ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: ' - '),
                                TextSpan(text: trigger.info ?? ''),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('No reflux triggers found'),
                      ),
                  ],
                  const SizedBox(height: 8),
                  if (analysis.allergens != null) ...[
                    const Text(
                      'Allergens:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (analysis.allergens!.isNotEmpty)
                      ...analysis.allergens!.map<Widget>(
                        (allergen) => Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RichText(
                            text: TextSpan(
                              text: '• ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: allergen.name ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: ' - '),
                                TextSpan(text: allergen.info ?? ''),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('No allergens found'),
                      ),
                  ],
                  const SizedBox(height: 8),
                  if (analysis.calories != null)
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          const TextSpan(
                            text: 'Calories: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: analysis.calories.toString()),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (analysis.nutritionFacts != null &&
                      analysis.nutritionFacts!.isNotEmpty) ...[
                    const Text(
                      'Nutrition Facts:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...analysis.nutritionFacts!.map(
                      (fact) => Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              const TextSpan(text: '• '),
                              TextSpan(
                                text: fact.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: ': ${fact.value}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
