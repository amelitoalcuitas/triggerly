import 'database_helper.dart';
import '../models/health_profile.dart';

class HealthProfileDB {
  static final HealthProfileDB instance = HealthProfileDB._init();
  final _dbHelper = DatabaseHelper.instance;

  HealthProfileDB._init();

  Future<void> saveHealthProfile(HealthProfile profile) async {
    final db = await _dbHelper.database;

    // Delete all existing profiles first (we only keep one profile)
    await db.delete('health_profile');

    // Insert the new profile
    await db.insert('health_profile', {
      'age': profile.age,
      'height': profile.height,
      'weight': profile.weight,
      'blood_type': profile.bloodType,
      'medical_conditions': profile.medicalConditions.join('|'),
      'allergies': profile.allergies.join('|'),
      'medications': profile.medications.join('|'),
    });
  }

  Future<HealthProfile?> getHealthProfile() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('health_profile');

    if (maps.isEmpty) return null;

    final map = maps.first;
    return HealthProfile(
      age: map['age'] as int,
      height: map['height'] as double,
      weight: map['weight'] as double,
      bloodType: map['blood_type'] as String,
      medicalConditions: (map['medical_conditions'] as String).split('|'),
      allergies: (map['allergies'] as String).split('|'),
      medications: (map['medications'] as String).split('|'),
    );
  }

  Future<void> deleteHealthProfile() async {
    final db = await _dbHelper.database;
    await db.delete('health_profile');
  }
}
