import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triggerly/app/providers/health_profile_provider.dart';

class BMICalculatorPage extends ConsumerStatefulWidget {
  const BMICalculatorPage({super.key});

  @override
  ConsumerState<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends ConsumerState<BMICalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  double? _bmi;
  String? _bmiCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHealthProfileData();
    });
  }

  void _loadHealthProfileData() {
    final healthProfile = ref.read(healthProfileProvider);
    if (healthProfile != null &&
        healthProfile.height > 0 &&
        healthProfile.weight > 0) {
      setState(() {
        _heightController.text = healthProfile.height.toString();
        _weightController.text = healthProfile.weight.toString();
      });
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    if (_formKey.currentState?.validate() ?? false) {
      final height =
          double.parse(_heightController.text) / 100; // Convert cm to m
      final weight = double.parse(_weightController.text);

      setState(() {
        _bmi = weight / (height * height);
        _bmiCategory = _getBMICategory(_bmi!);
      });
    }
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal weight';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color _getBMICategoryColor(double bmi) {
    if (bmi < 18.5) return Colors.yellow;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  String _getTargetWeightRange() {
    final height = double.tryParse(_heightController.text) ?? 0;
    if (height <= 0) return '';

    // Convert height from cm to m
    final heightInMeters = height / 100;

    // Calculate min and max weight for normal BMI (18.5 to 24.9)
    final minWeight = 18.5 * (heightInMeters * heightInMeters);
    final maxWeight = 24.9 * (heightInMeters * heightInMeters);

    return '${minWeight.toStringAsFixed(1)} - ${maxWeight.toStringAsFixed(1)} kg';
  }

  String _getBMIMessage() {
    if (_bmi == null) return '';

    final height = double.tryParse(_heightController.text) ?? 0;
    if (height <= 0) return '';

    final heightInMeters = height / 100;
    final currentWeight = double.tryParse(_weightController.text) ?? 0;

    if (_bmi! < 18.5) {
      final targetWeight = 18.5 * (heightInMeters * heightInMeters);
      final weightToGain = targetWeight - currentWeight;
      return 'You need to gain ${weightToGain.toStringAsFixed(1)} kg to reach normal weight';
    } else if (_bmi! >= 25) {
      final targetWeight = 24.9 * (heightInMeters * heightInMeters);
      final weightToLose = currentWeight - targetWeight;
      return 'You need to lose ${weightToLose.toStringAsFixed(1)} kg to reach normal weight';
    } else {
      return 'Great job! You are within the healthy weight range';
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(healthProfileProvider, (previous, next) {
      if (next != null &&
          next.height > 0 &&
          next.weight > 0 &&
          (_heightController.text.isEmpty || _weightController.text.isEmpty)) {
        _loadHealthProfileData();
      }
    });

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('BMI Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          labelText: 'Height (cm)',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your height';
                          }
                          final height = double.tryParse(value);
                          if (height == null || height <= 0) {
                            return 'Please enter a valid height';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          labelText: 'Weight (kg)',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your weight';
                          }
                          final weight = double.tryParse(value);
                          if (weight == null || weight <= 0) {
                            return 'Please enter a valid weight';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculateBMI,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Calculate BMI'),
              ),
              if (_bmi != null) ...[
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Your BMI', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          _bmi!.toStringAsFixed(1),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _bmiCategory!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: _getBMICategoryColor(_bmi!),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_bmi != null && (_bmi! < 18.5 || _bmi! >= 25)) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(
                            'Target Weight Range for Normal BMI',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getTargetWeightRange(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          _getBMIMessage(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _getBMICategoryColor(_bmi!),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
