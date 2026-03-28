import 'package:flutter/material.dart';

import 'kali_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: KaliColors.accentPrimary,
      onPrimary: Colors.white,
      secondary: KaliColors.bgTertiary,
      onSecondary: KaliColors.textPrimary,
      surface: KaliColors.bgSecondary,
      onSurface: KaliColors.textPrimary,
      error: KaliColors.accentDanger,
      onError: Colors.white,
      errorContainer: KaliColors.accentDanger.withValues(alpha: 0.15),
      onErrorContainer: KaliColors.accentDanger,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: KaliColors.bgPrimary,
      appBarTheme: const AppBarTheme(
        backgroundColor: KaliColors.bgSecondary,
        foregroundColor: KaliColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardTheme(
        color: KaliColors.bgSecondary,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: KaliColors.borderColor),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: KaliColors.accentPrimary,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: KaliColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: KaliColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: KaliColors.accentPrimary, width: 2),
        ),
        labelStyle: const TextStyle(color: KaliColors.textSecondary),
        hintStyle: const TextStyle(color: KaliColors.textMuted),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return KaliColors.accentPrimary;
            }
            return KaliColors.bgTertiary;
          }),
          foregroundColor: WidgetStateProperty.all(KaliColors.textPrimary),
          side: WidgetStateProperty.all(
            const BorderSide(color: KaliColors.borderColor),
          ),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: KaliColors.borderColor),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: KaliColors.borderColor,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: KaliColors.bgTertiary,
        contentTextStyle: const TextStyle(color: KaliColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: KaliColors.bgTertiary,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titleTextStyle: const TextStyle(
          color: KaliColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: KaliColors.textSecondary,
          fontSize: 15,
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: KaliColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: KaliColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: KaliColors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: KaliColors.textSecondary,
        ),
        bodySmall: TextStyle(
          color: KaliColors.textSecondary,
        ),
      ),
    );
  }
}
