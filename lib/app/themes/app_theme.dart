import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF03A791);

  // Light theme colors
  static final ColorScheme lightColorScheme = ColorScheme.light(
    primary: primaryColor,
    secondary: primaryColor.withValues(alpha: 0.7),
    surface: Colors.white,
    error: Colors.red[700]!,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.grey[900]!,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  // Dark theme colors
  static final ColorScheme darkColorScheme = ColorScheme.dark(
    primary: primaryColor,
    secondary: primaryColor.withValues(alpha: 0.7),
    surface: const Color(0xFF121212),
    error: Colors.red[300]!,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: lightColorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.surface,
      foregroundColor: lightColorScheme.onSurface,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      surfaceTintColor: lightColorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: lightColorScheme.onPrimary,
        backgroundColor: lightColorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textTheme: Typography.material2021().black,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: darkColorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface,
      foregroundColor: darkColorScheme.onSurface,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      surfaceTintColor: darkColorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: darkColorScheme.onPrimary,
        backgroundColor: darkColorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textTheme: Typography.material2021().white,
  );
}
