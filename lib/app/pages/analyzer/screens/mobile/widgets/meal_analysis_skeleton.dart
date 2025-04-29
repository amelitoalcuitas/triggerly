import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MealAnalysisSkeleton extends StatelessWidget {
  const MealAnalysisSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sample Meal Name',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'This is a sample description of the meal being analyzed...',
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ingredients:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text('• Sample ingredient 1'),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text('• Sample ingredient 2'),
          ),
        ],
      ),
    );
  }
}
