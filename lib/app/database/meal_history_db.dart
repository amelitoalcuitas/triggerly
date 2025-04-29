import 'database_helper.dart';
import '../models/meal_analysis.dart';

class MealHistoryDB {
  static final MealHistoryDB instance = MealHistoryDB._init();
  final _dbHelper = DatabaseHelper.instance;

  MealHistoryDB._init();

  Future<Map<String, dynamic>> saveMealAnalysis(MealAnalysis analysis) async {
    final db = await _dbHelper.database;

    final id = await db.insert('meal_history', {
      'meal_name': analysis.mealName,
      'ingredients': analysis.ingredients?.join('|'),
      'reflux_triggers': analysis.refluxTriggers
          ?.map((t) => t.toJson())
          .join('|'),
      'calories': analysis.calories,
      'nutrition_facts': analysis.nutritionFacts
          ?.map((f) => f.toJson())
          .join('|'),
      'allergens': analysis.allergens?.map((a) => a.toJson()).join('|'),
      'message': analysis.message,
      'is_error': analysis.isError == true ? 1 : 0,
      'image_path': analysis.imagePath,
      'user_triggered': null,
      'created_at': DateTime.now().toIso8601String(),
    });

    final savedAnalysis = await db.query(
      'meal_history',
      where: 'id = ?',
      whereArgs: [id],
    );

    return savedAnalysis.first;
  }

  Future<Map<String, dynamic>> updateMealAnalysis(
    int id,
    MealAnalysis analysis,
  ) async {
    final db = await _dbHelper.database;

    // Get the existing meal to preserve its image path
    final existingMeal = await getMealById(id);
    final imagePath = analysis.imagePath ?? existingMeal?['image_path'];

    await db.update(
      'meal_history',
      {
        'meal_name': analysis.mealName,
        'ingredients': analysis.ingredients?.join('|'),
        'reflux_triggers': analysis.refluxTriggers
            ?.map((t) => t.toJson())
            .join('|'),
        'calories': analysis.calories,
        'nutrition_facts': analysis.nutritionFacts
            ?.map((f) => f.toJson())
            .join('|'),
        'allergens': analysis.allergens?.map((a) => a.toJson()).join('|'),
        'message': analysis.message,
        'is_error': analysis.isError == true ? 1 : 0,
        'image_path': imagePath,
        'created_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    final updatedAnalysis = await db.query(
      'meal_history',
      where: 'id = ?',
      whereArgs: [id],
    );

    return updatedAnalysis.first;
  }

  Future<List<Map<String, dynamic>>> getMealHistory() async {
    final db = await _dbHelper.database;
    return await db.query('meal_history', orderBy: 'created_at DESC');
  }

  Future<Map<String, dynamic>?> getMealById(int id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'meal_history',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> deleteMealHistory(int id) async {
    final db = await _dbHelper.database;
    await db.delete('meal_history', where: 'id = ?', whereArgs: [id]);
  }
}
