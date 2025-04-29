import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triggerly/app/models/meal_analysis.dart';
import 'package:triggerly/app/pages/analyzer/screens/mobile/widgets/meal_analysis_skeleton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:triggerly/app/constants/prompts.dart';
import 'package:triggerly/app/pages/analyzer/screens/mobile/widgets/input_section.dart';
import 'package:triggerly/app/pages/analyzer/screens/mobile/widgets/meal_analysis_card.dart';
import 'package:triggerly/app/pages/analyzer/screens/mobile/widgets/meal_feedback_widget.dart';
import 'package:triggerly/app/providers/health_profile_provider.dart';
import 'package:triggerly/app/providers/meal_history_provider.dart';
import 'package:triggerly/app/shared/layouts/chat_scaffold.dart';
import 'package:triggerly/app/storage/image_storage.dart';
import 'package:triggerly/app/database/database_helper.dart';
import 'package:triggerly/app/shared/widgets/empty_state_widget.dart';

class AnalyzerPage extends ConsumerStatefulWidget {
  const AnalyzerPage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<AnalyzerPage> createState() => _AnalyzerPageState();
}

class _AnalyzerPageState extends ConsumerState<AnalyzerPage> {
  final _textController = TextEditingController();
  MealAnalysis? _mealAnalysis;
  bool _isLoading = false;
  File? _pickedImage;
  bool _isImageExpanded = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  Future<void> _pickImage({String type = 'gallery'}) async {
    ImagePicker picker = ImagePicker();

    final res = await picker.pickImage(
      source: type == 'gallery' ? ImageSource.gallery : ImageSource.camera,
    );

    if (res != null) {
      final imageFile = File(res.path);
      final savedPath = await ImageStorage.instance.saveImage(imageFile);
      setState(() {
        _pickedImage = File(savedPath);
      });
    } else {
      if (kDebugMode) {
        print('User cancelled the picker');
      }
    }
  }

  void _sendPrompt() async {
    setState(() => _isLoading = true);

    final prompt = _textController.text;
    final gemini = Gemini.instance;
    final healthProfile = ref.read(healthProfileProvider);
    final selectedMeal = ref.read(selectedMealProvider);

    try {
      _textController.clear();

      // Create health profile context string
      String healthProfileContext = '';
      if (healthProfile != null) {
        healthProfileContext = '''
          User Health Profile:
          Age: ${healthProfile.age}
          Height: ${healthProfile.height}cm
          Weight: ${healthProfile.weight}kg
          Blood Type: ${healthProfile.bloodType}
          Medical Conditions: ${healthProfile.medicalConditions.join(', ')}
          Allergies: ${healthProfile.allergies.join(', ')}
          Medications: ${healthProfile.medications.join(', ')}

          Please analyze this meal considering the user's health profile above.
        ''';
      }

      // Create previous meal context if available
      String previousMealContext = '';
      File? previousMealImage;
      if (selectedMeal != null) {
        final previousAnalysis = MealAnalysis.fromMap(selectedMeal);
        previousMealContext = '''
          Previous Meal Analysis:
          ${previousAnalysis.toJson()}
        ''';
        if (previousAnalysis.imagePath != null) {
          previousMealImage = File(previousAnalysis.imagePath!);
        }
      }

      final parts = <Part>[
        Part.text(defaultPrompt),
        Part.text(healthProfileContext),
        if (previousMealContext.isNotEmpty) Part.text(previousMealContext),
        Part.text('(Start of user prompt "$prompt" End of user prompt)'),
        // Only include previous meal image if there's no new picked image
        if (previousMealImage != null && _pickedImage == null)
          Part.inline(
            InlineData(
              mimeType: 'image/jpeg',
              data: base64Encode(previousMealImage.readAsBytesSync()),
            ),
          ),
        // Only include new picked image if it exists
        if (_pickedImage != null)
          Part.inline(
            InlineData(
              mimeType: 'image/jpeg',
              data: base64Encode(_pickedImage!.readAsBytesSync()),
            ),
          ),
      ];

      final result = await gemini.prompt(parts: parts);

      setState(() {
        final jsonResponse = result?.output;

        if (jsonResponse != null) {
          print('jsonResponse: $jsonResponse');

          _mealAnalysis = MealAnalysis.fromJson(jsonResponse);

          // Add the image path to the meal analysis
          if (_pickedImage != null) {
            _mealAnalysis = _mealAnalysis?.copyWith(
              imagePath: _pickedImage!.path,
            );
          }

          // Update or save the meal analysis
          if (_mealAnalysis != null && _mealAnalysis?.isError != true) {
            if (selectedMeal != null) {
              // Update existing meal analysis
              ref
                  .read(mealHistoryProvider.notifier)
                  .updateMealAnalysis(selectedMeal['id'], _mealAnalysis!)
                  .then((updatedAnalysis) {
                    ref.read(selectedMealProvider.notifier).state =
                        updatedAnalysis;
                  });
            } else {
              // Save new meal analysis
              ref
                  .read(mealHistoryProvider.notifier)
                  .saveMealAnalysis(_mealAnalysis!)
                  .then((savedAnalysis) {
                    ref.read(selectedMealProvider.notifier).state =
                        savedAnalysis;
                  });
            }
          }
        } else {
          _mealAnalysis = MealAnalysis(message: 'No response.');
        }
      });
    } catch (e) {
      setState(() {
        _mealAnalysis = MealAnalysis(message: 'An error occurred: $e');
      });
    } finally {
      setState(() => _isLoading = false);
      _isImageExpanded = false;
      _pickedImage = null;
    }
  }

  Future<void> _updateUserTriggered(bool triggered) async {
    final selectedMeal = ref.read(selectedMealProvider);
    if (selectedMeal != null) {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        'meal_history',
        {'user_triggered': triggered ? 1 : 0},
        where: 'id = ?',
        whereArgs: [selectedMeal['id']],
      );

      // Update the provider state
      ref.read(selectedMealProvider.notifier).state = {
        ...selectedMeal,
        'user_triggered': triggered ? 1 : 0,
      };

      // Refresh the meal history
      await ref.read(mealHistoryProvider.notifier).loadMealHistory();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thank you for your feedback!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedMeal = ref.watch(selectedMealProvider);
    final currentAnalysis =
        selectedMeal != null ? MealAnalysis.fromMap(selectedMeal) : null;
    final showFeedbackRow =
        selectedMeal?['user_triggered'] == null && !_isLoading;
    final userTriggered = selectedMeal?['user_triggered'];

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Future.delayed(const Duration(milliseconds: 150), () {
            ref.read(selectedMealProvider.notifier).state = null;
          });
        }
      },
      child: ChatScaffold(
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          if (showFeedbackRow &&
                              currentAnalysis != null &&
                              currentAnalysis.isError != true)
                            MealFeedbackWidget(
                              currentAnalysis: currentAnalysis,
                              onUpdateUserTriggered: _updateUserTriggered,
                            )
                          else if (userTriggered != null)
                            Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color:
                                    userTriggered == 1
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                userTriggered == 1
                                    ? 'This meal triggered your acid reflux symptoms.'
                                    : 'This meal did not trigger your acid reflux symptoms.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),

                          if (_isLoading)
                            const MealAnalysisSkeleton()
                          else if (currentAnalysis != null &&
                              currentAnalysis.isError != true)
                            MealAnalysisCard(
                              mealAnalysis: currentAnalysis,
                              isImageExpanded: _isImageExpanded,
                              onImageTap: () {
                                setState(() {
                                  _isImageExpanded = !_isImageExpanded;
                                });
                              },
                            )
                          else if (currentAnalysis != null &&
                              currentAnalysis.isError == true)
                            Text(
                              currentAnalysis.message ?? '',
                              style: const TextStyle(fontSize: 16),
                            )
                          else
                            EmptyStateWidget(
                              title: 'Welcome to Meal Analyzer',
                              subtitle:
                                  'Describe or upload an image of your meal\nto get personalized analysis',
                            ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (userTriggered == null)
              InputSection(
                textController: _textController,
                pickedImage: _pickedImage,
                isLoading: _isLoading,
                onSend: _sendPrompt,
                onPickImage: (type) async {
                  if (type.isEmpty) {
                    if (_pickedImage != null) {
                      await ImageStorage.instance.deleteImage(
                        _pickedImage!.path,
                      );
                    }
                    setState(() => _pickedImage = null);
                  } else {
                    _pickImage(type: type);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
