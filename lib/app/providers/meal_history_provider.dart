import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/meal_history_db.dart';
import '../models/meal_analysis.dart';
import '../storage/image_storage.dart';

final mealHistoryProvider =
    StateNotifierProvider<MealHistoryNotifier, List<Map<String, dynamic>>>((
      ref,
    ) {
      return MealHistoryNotifier();
    });

final selectedMealProvider = StateProvider<Map<String, dynamic>?>(
  (ref) => null,
);

class MealHistoryNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  MealHistoryNotifier() : super([]) {
    loadMealHistory();
  }

  Future<void> loadMealHistory() async {
    state = await MealHistoryDB.instance.getMealHistory();
  }

  Future<Map<String, dynamic>> saveMealAnalysis(MealAnalysis analysis) async {
    final savedAnalysis = await MealHistoryDB.instance.saveMealAnalysis(
      analysis,
    );
    await loadMealHistory();
    return savedAnalysis;
  }

  Future<Map<String, dynamic>> updateMealAnalysis(
    int id,
    MealAnalysis analysis,
  ) async {
    final updatedAnalysis = await MealHistoryDB.instance.updateMealAnalysis(
      id,
      analysis,
    );
    await loadMealHistory();
    return updatedAnalysis;
  }

  Future<void> deleteMealHistory(int id) async {
    // Get the meal to delete to access its image path
    final mealToDelete = await getMealById(id);
    if (mealToDelete != null && mealToDelete['image_path'] != null) {
      // Delete the associated image file
      await ImageStorage.instance.deleteImage(mealToDelete['image_path']);
    }

    // Delete the meal from the database
    await MealHistoryDB.instance.deleteMealHistory(id);
    await loadMealHistory();
  }

  Future<Map<String, dynamic>?> getMealById(int id) async {
    return await MealHistoryDB.instance.getMealById(id);
  }
}
