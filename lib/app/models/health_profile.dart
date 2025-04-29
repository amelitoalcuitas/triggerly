class HealthProfile {
  final int age;
  final double height; // in centimeters
  final double weight; // in kilograms
  final String bloodType;
  final List<String> medicalConditions;
  final List<String> allergies;
  final List<String> medications;

  HealthProfile({
    required this.age,
    required this.height,
    required this.weight,
    required this.bloodType,
    required this.medicalConditions,
    required this.allergies,
    required this.medications,
  });

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'height': height,
      'weight': weight,
      'bloodType': bloodType,
      'medicalConditions': medicalConditions,
      'allergies': allergies,
      'medications': medications,
    };
  }

  factory HealthProfile.fromJson(Map<String, dynamic> json) {
    return HealthProfile(
      age: json['age'] as int,
      height: json['height'] as double,
      weight: json['weight'] as double,
      bloodType: json['bloodType'] as String,
      medicalConditions: List<String>.from(json['medicalConditions']),
      allergies: List<String>.from(json['allergies']),
      medications: List<String>.from(json['medications']),
    );
  }
}
