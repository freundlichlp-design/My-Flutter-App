import 'package:flutter/material.dart';

import 'kali_colors.dart';
import 'kali_radius.dart';
import 'kali_spacing.dart';
import 'kali_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: KaliColors.accentPrimary,
      onPrimary: KaliColors.textInverse,
      secondary: KaliColors.bgTertiary,
      onSecondary: KaliColors.textPrimary,
      surface: KaliColors.bgSecondary,
      onSurface: KaliColors.textPrimary,
      error: KaliColors.accentDanger,
      onError: KaliColors.textInverse,
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
          borderRadius: KaliRadius.card,
          side: const BorderSide(color: KaliColors.borderColor),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: KaliColors.accentPrimary,
        foregroundColor: KaliColors.textInverse,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KaliRadius.md),
          borderSide: const BorderSide(color: KaliColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KaliRadius.md),
          borderSide: const BorderSide(color: KaliColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KaliRadius.md),
          borderSide: const BorderSide(color: KaliColors.borderFocus, width: 2),
        ),
        labelStyle: KaliTextStyles.label.copyWith(color: KaliColors.textSecondary),
        hintStyle: KaliTextStyles.muted,
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
            borderRadius: BorderRadius.circular(KaliRadius.md),
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
        contentTextStyle: KaliTextStyles.body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KaliRadius.md),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: KaliColors.bgTertiary,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KaliRadius.lg),
        ),
        titleTextStyle: KaliTextStyles.subtitle,
        contentTextStyle: KaliTextStyles.body.copyWith(color: KaliColors.textSecondary),
      ),
      textTheme: TextTheme(
        headlineSmall: KaliTextStyles.headline,
        titleMedium: KaliTextStyles.subtitle,
        bodyLarge: KaliTextStyles.body,
        bodyMedium: KaliTextStyles.body.copyWith(color: KaliColors.textSecondary),
        bodySmall: KaliTextStyles.caption,
      ),
    );
  }
}
