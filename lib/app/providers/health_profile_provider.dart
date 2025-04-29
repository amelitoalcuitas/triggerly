import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/health_profile.dart';
import '../database/health_profile_db.dart';

final healthProfileProvider =
    StateNotifierProvider<HealthProfileNotifier, HealthProfile?>((ref) {
      return HealthProfileNotifier();
    });

class HealthProfileNotifier extends StateNotifier<HealthProfile?> {
  HealthProfileNotifier() : super(null) {
    _loadHealthProfile();
  }

  Future<void> loadData() async {
    await _loadHealthProfile();
  }

  Future<void> _loadHealthProfile() async {
    state = await HealthProfileDB.instance.getHealthProfile();
  }

  Future<void> saveHealthProfile(HealthProfile profile) async {
    await HealthProfileDB.instance.saveHealthProfile(profile);
    state = profile;
  }

  Future<void> updateHealthProfile({
    int? age,
    double? height,
    double? weight,
    String? bloodType,
    List<String>? medicalConditions,
    List<String>? allergies,
    List<String>? medications,
  }) async {
    if (state == null) return;

    final updatedProfile = HealthProfile(
      age: age ?? state!.age,
      height: height ?? state!.height,
      weight: weight ?? state!.weight,
      bloodType: bloodType ?? state!.bloodType,
      medicalConditions: medicalConditions ?? state!.medicalConditions,
      allergies: allergies ?? state!.allergies,
      medications: medications ?? state!.medications,
    );

    await saveHealthProfile(updatedProfile);
  }

  Future<void> clearHealthProfile() async {
    await HealthProfileDB.instance.deleteHealthProfile();
    state = null;
  }
}
