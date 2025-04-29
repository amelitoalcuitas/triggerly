import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme(); // <-- Load saved theme at start
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme_mode') ?? 'light';

    if (theme == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await prefs.setString('theme_mode', 'dark');
    } else {
      state = ThemeMode.light;
      await prefs.setString('theme_mode', 'light');
    }
  }

  // Optional: Force functions
  Future<void> setLightMode() async {
    final prefs = await SharedPreferences.getInstance();
    state = ThemeMode.light;
    await prefs.setString('theme_mode', 'light');
  }

  Future<void> setDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    state = ThemeMode.dark;
    await prefs.setString('theme_mode', 'dark');
  }

  // Optional: Getters
  bool get isDarkMode => state == ThemeMode.dark;
}

// Provider
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);
