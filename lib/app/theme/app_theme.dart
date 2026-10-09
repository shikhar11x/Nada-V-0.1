import 'package:flutter/material.dart';

/// Design tokens. Change colours here and the whole app follows.
class AppColors {
  AppColors._();

  static const background = Color(0xFF121012); // page
  static const card = Color(0xFF1C1A1D); // cards, fields
  static const cardRaised = Color(0xFF262327); // avatars, icon buttons
  static const border = Color(0xFF332F34); // hairlines

  static const plum = Color(0xFF66295D); // primary buttons, badges
  static const plumLight = Color(0xFFD9A3D2); // plum-family text on dark
  static const plumTint = Color(0xFF2A1A28); // tinted card background
  static const plumBorder = Color(0xFF4A2A45);

  static const amber = Color(0xFFE59A4A); // sparkle / highlight, used sparingly

  static const cream = Color(0xFFF5EFE6); // main text
  static const muted = Color(0xFFA8A0A6); // secondary text
  static const error = Color(0xFFE57373);
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

  static const double card = 20;
  static const double field = 16;
  static const double pill = 999;
}

class AppTheme {
  AppTheme._();

  /// Headings font. 'serif' maps to Noto Serif on Android (with Devanagari).
  /// To use a bundled font such as Fraunces, change only this one line.
  static const String serifFamily = 'serif';

  static const TextTheme _textTheme = TextTheme(
    displaySmall: TextStyle(
      fontFamily: serifFamily,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.15,
      letterSpacing: -0.5,
      color: AppColors.cream,
    ),
    headlineSmall: TextStyle(
      fontFamily: serifFamily,
      fontSize: 26,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.3,
      color: AppColors.cream,
    ),
    titleLarge: TextStyle(
      fontFamily: serifFamily,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 1.25,
      color: AppColors.cream,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.cream,
    ),
    bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: AppColors.cream),
    bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: AppColors.cream),
    bodySmall: TextStyle(fontSize: 13, height: 1.4, color: AppColors.muted),
    labelLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: AppColors.cream,
    ),
    // Small uppercase label, e.g. "CONNECTED THROUGH". Apply .toUpperCase() in code.
    labelMedium: TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.6,
      color: AppColors.muted,
    ),
  );

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: AppColors.plum,
      onPrimary: AppColors.cream,
      primaryContainer: AppColors.plumTint,
      onPrimaryContainer: AppColors.plumLight,
      secondary: AppColors.amber,
      onSecondary: AppColors.background,
      surface: AppColors.background,
      onSurface: AppColors.cream,
      onSurfaceVariant: AppColors.muted,
      outline: AppColors.border,
      outlineVariant: AppColors.border,
      error: AppColors.error,
      onError: AppColors.background,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _textTheme,
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        space: 1,
        thickness: 1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.plum,
          foregroundColor: AppColors.cream,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.field),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        hintStyle: const TextStyle(color: AppColors.muted, fontSize: 15),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: _fieldBorder(AppColors.border),
        enabledBorder: _fieldBorder(AppColors.border),
        focusedBorder: _fieldBorder(AppColors.plumLight, width: 1.5),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.plumLight,
        selectionColor: AppColors.plumBorder,
        selectionHandleColor: AppColors.plumLight,
      ),
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.field),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}