import 'dart:convert';

import 'package:flutter/foundation.dart';

class MealAnalysis {
  String? mealName;
  List<String>? ingredients;
  List<RefluxTrigger>? refluxTriggers;
  String? calories;
  List<NutritionFact>? nutritionFacts;
  List<Allergen>? allergens;
  String? message;
  bool? isError;
  bool? isNotFood;
  String? imagePath;
  bool? userTriggered;

  MealAnalysis({
    this.mealName,
    this.ingredients,
    this.refluxTriggers,
    this.calories,
    this.nutritionFacts,
    this.allergens,
    this.message,
    this.isError,
    this.isNotFood,
    this.imagePath,
    this.userTriggered,
  });

  MealAnalysis copyWith({
    String? mealName,
    List<String>? ingredients,
    List<RefluxTrigger>? refluxTriggers,
    String? calories,
    List<NutritionFact>? nutritionFacts,
    List<Allergen>? allergens,
    String? message,
    bool? isError,
    bool? isNotFood,
    String? imagePath,
    bool? userTriggered,
  }) {
    return MealAnalysis(
      mealName: mealName ?? this.mealName,
      ingredients: ingredients ?? this.ingredients,
      refluxTriggers: refluxTriggers ?? this.refluxTriggers,
      calories: calories ?? this.calories,
      nutritionFacts: nutritionFacts ?? this.nutritionFacts,
      allergens: allergens ?? this.allergens,
      message: message ?? this.message,
      isError: isError ?? this.isError,
      isNotFood: isNotFood ?? this.isNotFood,
      imagePath: imagePath ?? this.imagePath,
      userTriggered: userTriggered ?? this.userTriggered,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (mealName != null) {
      result.addAll({'mealName': mealName});
    }
    if (ingredients != null) {
      result.addAll({'ingredients': ingredients});
    }
    if (refluxTriggers != null) {
      result.addAll({
        'refluxTriggers': refluxTriggers!.map((x) => x.toMap()).toList(),
      });
    }
    if (calories != null) {
      result.addAll({'calories': calories});
    }
    if (nutritionFacts != null) {
      result.addAll({
        'nutritionFacts': nutritionFacts!.map((x) => x.toMap()).toList(),
      });
    }
    if (allergens != null) {
      result.addAll({'allergens': allergens!.map((x) => x.toMap()).toList()});
    }
    if (message != null) {
      result.addAll({'message': message});
    }
    if (isError != null) {
      result.addAll({'isError': isError});
    }
    if (isNotFood != null) {
      result.addAll({'is_not_food': isNotFood});
    }
    if (imagePath != null) {
      result.addAll({'imagePath': imagePath});
    }
    if (userTriggered != null) {
      result.addAll({'userTriggered': userTriggered});
    }

    return result;
  }

  factory MealAnalysis.fromMap(Map<String, dynamic> map) {
    List<String>? parseIngredients(dynamic ingredientsData) {
      if (ingredientsData == null) return null;
      if (ingredientsData is List) return List<String>.from(ingredientsData);
      if (ingredientsData is String) return ingredientsData.split('|');
      return null;
    }

    List<RefluxTrigger>? parseRefluxTriggers(dynamic triggersData) {
      if (triggersData == null) return null;
      if (triggersData is List) {
        return triggersData
            .map((item) {
              if (item is Map<String, dynamic>) {
                return RefluxTrigger.fromMap(item);
              }
              if (item is String) {
                try {
                  return RefluxTrigger.fromJson(item);
                } catch (e) {
                  return null;
                }
              }
              return null;
            })
            .whereType<RefluxTrigger>()
            .toList();
      }
      if (triggersData is String) {
        return triggersData
            .split('|')
            .map((json) {
              try {
                return RefluxTrigger.fromJson(json);
              } catch (e) {
                return null;
              }
            })
            .whereType<RefluxTrigger>()
            .toList();
      }
      return null;
    }

    List<NutritionFact>? parseNutritionFacts(dynamic factsData) {
      if (factsData == null) return null;
      if (factsData is List) {
        return factsData
            .map((item) {
              if (item is Map<String, dynamic>) {
                return NutritionFact.fromMap(item);
              }
              if (item is String) {
                try {
                  return NutritionFact.fromJson(item);
                } catch (e) {
                  return null;
                }
              }
              return null;
            })
            .whereType<NutritionFact>()
            .toList();
      }
      if (factsData is String) {
        return factsData
            .split('|')
            .map((json) {
              try {
                return NutritionFact.fromJson(json);
              } catch (e) {
                return null;
              }
            })
            .whereType<NutritionFact>()
            .toList();
      }
      return null;
    }

    List<Allergen>? parseAllergens(dynamic allergensData) {
      if (allergensData == null) return null;
      if (allergensData is List) {
        return allergensData
            .map((item) {
              if (item is Map<String, dynamic>) {
                return Allergen.fromMap(item);
              }
              if (item is String) {
                try {
                  return Allergen.fromJson(item);
                } catch (e) {
                  return null;
                }
              }
              return null;
            })
            .whereType<Allergen>()
            .toList();
      }
      if (allergensData is String) {
        return allergensData
            .split('|')
            .map((json) {
              try {
                return Allergen.fromJson(json);
              } catch (e) {
                return null;
              }
            })
            .whereType<Allergen>()
            .toList();
      }
      return null;
    }

    return MealAnalysis(
      mealName: map['meal_name'],
      ingredients: parseIngredients(map['ingredients']),
      refluxTriggers: parseRefluxTriggers(map['reflux_triggers']),
      calories: map['calories'],
      nutritionFacts: parseNutritionFacts(map['nutrition_facts']),
      allergens: parseAllergens(map['allergens']),
      message: map['message'],
      isError: map['is_error'] == true || map['is_error'] == 1,
      isNotFood: map['is_not_food'] == true || map['is_not_food'] == 1,
      imagePath: map['image_path'],
      userTriggered:
          map['user_triggered'] == true || map['user_triggered'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory MealAnalysis.fromJson(String source) =>
      MealAnalysis.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MealAnalysis(mealName: $mealName, ingredients: $ingredients, refluxTriggers: $refluxTriggers, calories: $calories, nutritionFacts: $nutritionFacts, allergens: $allergens, message: $message, isError: $isError, isNotFood: $isNotFood, imagePath: $imagePath, userTriggered: $userTriggered)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MealAnalysis &&
        other.mealName == mealName &&
        listEquals(other.ingredients, ingredients) &&
        listEquals(other.refluxTriggers, refluxTriggers) &&
        other.calories == calories &&
        listEquals(other.nutritionFacts, nutritionFacts) &&
        listEquals(other.allergens, allergens) &&
        other.message == message &&
        other.isError == isError &&
        other.isNotFood == isNotFood &&
        other.imagePath == imagePath &&
        other.userTriggered == userTriggered;
  }

  @override
  int get hashCode {
    return mealName.hashCode ^
        ingredients.hashCode ^
        refluxTriggers.hashCode ^
        calories.hashCode ^
        nutritionFacts.hashCode ^
        allergens.hashCode ^
        message.hashCode ^
        isError.hashCode ^
        isNotFood.hashCode ^
        imagePath.hashCode ^
        userTriggered.hashCode;
  }
}

class RefluxTrigger {
  String? trigger;
  String? info;

  RefluxTrigger({this.trigger, this.info});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (trigger != null) {
      result.addAll({'trigger': trigger});
    }
    if (info != null) {
      result.addAll({'info': info});
    }

    return result;
  }

  factory RefluxTrigger.fromMap(Map<String, dynamic> map) {
    return RefluxTrigger(trigger: map['trigger'], info: map['info']);
  }

  String toJson() => json.encode(toMap());

  factory RefluxTrigger.fromJson(String source) =>
      RefluxTrigger.fromMap(json.decode(source));
}

class NutritionFact {
  String? name;
  String? value;

  NutritionFact({this.name, this.value});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (name != null) {
      result.addAll({'name': name});
    }
    if (value != null) {
      result.addAll({'value': value});
    }

    return result;
  }

  factory NutritionFact.fromMap(Map<String, dynamic> map) {
    return NutritionFact(name: map['name'], value: map['value']);
  }

  String toJson() => json.encode(toMap());

  factory NutritionFact.fromJson(String source) =>
      NutritionFact.fromMap(json.decode(source));
}

class Allergen {
  String? name;
  String? info;

  Allergen({this.name, this.info});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (name != null) {
      result.addAll({'name': name});
    }
    if (info != null) {
      result.addAll({'info': info});
    }

    return result;
  }

  factory Allergen.fromMap(Map<String, dynamic> map) {
    return Allergen(name: map['name'], info: map['info']);
  }

  String toJson() => json.encode(toMap());

  factory Allergen.fromJson(String source) =>
      Allergen.fromMap(json.decode(source));
}
