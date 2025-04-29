import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/health_profile.dart';
import '../../../../providers/health_profile_provider.dart';

class HealthProfilePage extends ConsumerStatefulWidget {
  const HealthProfilePage({super.key});

  @override
  ConsumerState<HealthProfilePage> createState() => _HealthProfilePageState();
}

class _HealthProfilePageState extends ConsumerState<HealthProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _medicalConditionsController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medicationsController = TextEditingController();

  // Store initial values for comparison
  String _initialAge = '';
  String _initialHeight = '';
  String _initialWeight = '';
  String _initialBloodType = '';
  String _initialMedicalConditions = '';
  String _initialAllergies = '';
  String _initialMedications = '';

  bool _isLoading = true;

  bool get _isFormDirty {
    return _ageController.text != _initialAge ||
        _heightController.text != _initialHeight ||
        _weightController.text != _initialWeight ||
        _bloodTypeController.text != _initialBloodType ||
        _medicalConditionsController.text != _initialMedicalConditions ||
        _allergiesController.text != _initialAllergies ||
        _medicationsController.text != _initialMedications;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingData();
    });

    // Add listeners to all controllers
    _ageController.addListener(_onTextChanged);
    _heightController.addListener(_onTextChanged);
    _weightController.addListener(_onTextChanged);
    _bloodTypeController.addListener(_onTextChanged);
    _medicalConditionsController.addListener(_onTextChanged);
    _allergiesController.addListener(_onTextChanged);
    _medicationsController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {}); // Trigger rebuild when any text changes
  }

  void _loadExistingData() async {
    setState(() {
      _isLoading = true;
    });

    // Wait for the provider to load the data
    await Future.delayed(const Duration(milliseconds: 100));

    // Get the notifier and ensure data is loaded
    final notifier = ref.read(healthProfileProvider.notifier);
    await notifier.loadData();

    final profile = ref.read(healthProfileProvider);
    if (profile != null) {
      _ageController.text = profile.age.toString();
      _heightController.text = profile.height.toString();
      _weightController.text = profile.weight.toString();
      _bloodTypeController.text = profile.bloodType;
      _medicalConditionsController.text = profile.medicalConditions.join(', ');
      _allergiesController.text = profile.allergies.join(', ');
      _medicationsController.text = profile.medications.join(', ');
    } else {
      // Set default empty values when no profile exists
      _ageController.text = '';
      _heightController.text = '';
      _weightController.text = '';
      _bloodTypeController.text = '';
      _medicalConditionsController.text = '';
      _allergiesController.text = '';
      _medicationsController.text = '';
    }

    // Store initial values
    _initialAge = _ageController.text;
    _initialHeight = _heightController.text;
    _initialWeight = _weightController.text;
    _initialBloodType = _bloodTypeController.text;
    _initialMedicalConditions = _medicalConditionsController.text;
    _initialAllergies = _allergiesController.text;
    _initialMedications = _medicationsController.text;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // Remove listeners
    _ageController.removeListener(_onTextChanged);
    _heightController.removeListener(_onTextChanged);
    _weightController.removeListener(_onTextChanged);
    _bloodTypeController.removeListener(_onTextChanged);
    _medicalConditionsController.removeListener(_onTextChanged);
    _allergiesController.removeListener(_onTextChanged);
    _medicationsController.removeListener(_onTextChanged);

    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bloodTypeController.dispose();
    _medicalConditionsController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    super.dispose();
  }

  List<String> _parseListInput(String input) {
    if (input.isEmpty) return [];
    return input
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      final profile = HealthProfile(
        age: int.parse(_ageController.text),
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        bloodType: _bloodTypeController.text,
        medicalConditions: _parseListInput(_medicalConditionsController.text),
        allergies: _parseListInput(_allergiesController.text),
        medications: _parseListInput(_medicationsController.text),
      );

      ref.read(healthProfileProvider.notifier).saveHealthProfile(profile);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Health profile saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Health Profile',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 24,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body:
          _isLoading
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading your health profile...'),
                  ],
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _ageController,
                                    decoration: const InputDecoration(
                                      labelText: 'Age',
                                      hintText: 'Enter your age',
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your age';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Please enter a valid number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _heightController,
                                    decoration: const InputDecoration(
                                      labelText: 'Height (cm)',
                                      hintText: 'Enter height',
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your height';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Please enter a valid number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _weightController,
                                    decoration: const InputDecoration(
                                      labelText: 'Weight (kg)',
                                      hintText: 'Enter weight',
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your weight';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Please enter a valid number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _bloodTypeController,
                                    decoration: const InputDecoration(
                                      labelText: 'Blood Type',
                                      hintText: 'e.g., A+, B-',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your blood type';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _medicalConditionsController,
                              decoration: const InputDecoration(
                                labelText: 'Medical Conditions',
                                hintText:
                                    'Enter medical conditions (comma-separated)',
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _allergiesController,
                              decoration: const InputDecoration(
                                labelText: 'Allergies',
                                hintText: 'Enter allergies (comma-separated)',
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _medicationsController,
                              decoration: const InputDecoration(
                                labelText: 'Medications',
                                hintText: 'Enter medications (comma-separated)',
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _isFormDirty ? _saveProfile : null,
                      child: const Text('Save Health Profile'),
                    ),
                  ),
                ],
              ),
    );
  }
}
