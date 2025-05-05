import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF03A791);

  // Light theme colors
  static final ColorScheme lightColorScheme = ColorScheme.light(
    primary: primaryColor,
    secondary: primaryColor.withValues(alpha: 0.7),
    surface: const Color(0xFFEDFDFD),
    error: const Color(0xFFED1C24),
    onPrimary: const Color(0xFFEDFDFD),
    onSecondary: const Color(0xFFEDFDFD),
    onSurface: const Color(0xFF071E22),
    onError: const Color(0xFFEDFDFD),
    brightness: Brightness.light,
  );

  // Dark theme colors
  static final ColorScheme darkColorScheme = ColorScheme.dark(
    primary: primaryColor,
    secondary: primaryColor.withValues(alpha: 0.7),
    surface: const Color(0xFF071E22),
    error: const Color(0xFFFF4D4D),
    onPrimary: const Color(0xFFEDFDFD),
    onSecondary: const Color(0xFFEDFDFD),
    onSurface: const Color(0xFFEDFDFD),
    onError: const Color(0xFF071E22),
    brightness: Brightness.dark,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: lightColorScheme.surface,
    dividerTheme: DividerThemeData(
      color: lightColorScheme.onSurface.withAlpha(50),
      thickness: 0.5,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.surface,
      foregroundColor: lightColorScheme.onSurface,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: lightColorScheme.primary,
        fontSize: 24,
        fontWeight: FontWeight.normal,
      ),
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
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: lightColorScheme.onSurface),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: darkColorScheme.surface,
    dividerTheme: DividerThemeData(
      color: darkColorScheme.onSurface.withAlpha(50),
      thickness: 0.5,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface,
      foregroundColor: darkColorScheme.onSurface,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: darkColorScheme.primary,
        fontSize: 24,
        fontWeight: FontWeight.normal,
      ),
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
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: darkColorScheme.onSurface),
    ),
  );
}
