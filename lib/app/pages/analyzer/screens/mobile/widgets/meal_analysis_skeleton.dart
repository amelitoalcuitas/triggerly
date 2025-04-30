import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MealAnalysisSkeleton extends StatelessWidget {
  const MealAnalysisSkeleton({super.key, this.hasImage = false});

  final bool hasImage;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasImage)
            Skeleton.shade(
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey,
                ),
              ),
            ),
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
