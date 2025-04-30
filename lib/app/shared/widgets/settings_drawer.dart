import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triggerly/app/themes/theme_provider.dart';
import 'package:go_router/go_router.dart';

class SettingsDrawer extends ConsumerWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final isDarkMode = ref.watch(themeNotifierProvider) == ThemeMode.dark;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Settings', style: TextStyle(fontSize: 24)),
                  IconButton(
                    icon: Icon(
                      isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: isDarkMode ? Colors.yellow : Colors.teal,
                    ),
                    onPressed: () {
                      themeNotifier.toggleTheme();
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_rounded),
              title: const Text('Health Profile'),
              onTap: () {
                context.push('/health-profile');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate_rounded),
              title: const Text('BMI Calculator'),
              onTap: () {
                context.push('/bmi-calculator');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
