import 'package:flutter/material.dart';

/// Design tokens. Change colours here and the whole app follows.
class AppColors {
  AppColors._();

  static const ivory = Color(0xFFFBF6EE); // page background
  static const card = Color(0xFFFFFDF9); // card / field surface
  static const burgundy = Color(0xFF6E1F3A); // primary accent
  static const burgundySoft = Color(0xFFF6E9ED); // tinted burgundy background
  static const gold = Color(0xFFB8923A); // decorative only (borders, rules)
  static const goldText = Color(0xFF86661C); // gold that is readable as text
  static const border = Color(0xFFE6D9BC); // champagne hairline
  static const charcoal = Color(0xFF2B2427); // main text
  static const muted = Color(0xFF6B5F63); // secondary text
  static const error = Color(0xFFA32A2A);
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class AppRadius {
  AppRadius._();

  static const double card = 16;
  static const double field = 14;
  static const double chip = 999;
}

class AppTheme {
  AppTheme._();

  /// Platform serif. Android maps this to Noto Serif (with Devanagari fallback).
  static const String serifFamily = 'serif';

  static const TextTheme _textTheme = TextTheme(
    displaySmall: TextStyle(
      fontFamily: serifFamily,
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.15,
      color: AppColors.charcoal,
    ),
    headlineSmall: TextStyle(
      fontFamily: serifFamily,
      fontSize: 26,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: AppColors.charcoal,
    ),
    titleLarge: TextStyle(
      fontFamily: serifFamily,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.25,
      color: AppColors.charcoal,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.charcoal,
    ),
    bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: AppColors.charcoal),
    bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: AppColors.charcoal),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.charcoal,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
      color: AppColors.muted,
    ),
  );

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.burgundy,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.burgundy,
      onPrimary: AppColors.ivory,
      secondary: AppColors.gold,
      onSecondary: AppColors.charcoal,
      surface: AppColors.ivory,
      onSurface: AppColors.charcoal,
      surfaceTint: Colors.transparent,
      outline: AppColors.border,
      outlineVariant: AppColors.border,
      error: AppColors.error,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.ivory,
      textTheme: _textTheme,
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        space: 1,
        thickness: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.burgundy,
          foregroundColor: AppColors.ivory,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.field),
          ),
        ),
      ),
    );
  }
}