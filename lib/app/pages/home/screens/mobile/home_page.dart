import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:triggerly/app/providers/meal_history_provider.dart';
import 'package:triggerly/app/providers/navigation_provider.dart';
import 'package:triggerly/app/shared/layouts/main_scaffold.dart';
import 'package:triggerly/app/pages/charts/screens/mobile/charts_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    return MainScaffold(
      body:
          currentIndex == 0
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome to Acid Reflux Tracker',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Track and manage your acid reflux symptoms',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(selectedMealProvider.notifier).state = null;
                        context.push('/analyzer');
                      },
                      child: const Text('Get Started'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              )
              : const ChartsPage(),
    );
  }
}
