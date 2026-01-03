import 'package:flutter/material.dart';
import 'package:music/core/theme/app_colors.dart';
import 'package:music/core/theme/app_gradients.dart';
import 'package:music/core/theme/app_typography.dart';

class AppTheme {
  static final dark =
      ThemeData(
        fontFamily: "Lufga",
        useMaterial3: true,
        brightness: Brightness.dark,
      ).copyWith(
        extensions: [_darkAppColors, AppTypography.dark, AppGradients.dark],
        colorScheme: ColorScheme.fromSeed(
          seedColor: _darkAppColors.primary,
          brightness: Brightness.dark,
          primary: _darkAppColors.primary,
          secondary: _darkAppColors.secondary,
          error: _darkAppColors.error,
          surface: _darkAppColors.surfaceLight,
          background: _darkAppColors.background,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          titleTextStyle: AppTypography.dark.titleLarge.copyWith(
            color: _darkAppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: _darkAppColors.textPrimary),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: _darkAppColors.background,
          elevation: 0,
          indicatorColor: _darkAppColors.primary.withValues(alpha: 0.15),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final color = states.contains(WidgetState.selected)
                ? _darkAppColors.primary
                : _darkAppColors.textSecondary;
            return TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }),
        ),
        cardTheme: CardThemeData(
          color: _darkAppColors.surfaceLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: _darkAppColors.border, width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _darkAppColors.primary,
            foregroundColor: _darkAppColors.black,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            textStyle: AppTypography.dark.button.copyWith(
              fontWeight: FontWeight.w700,
              color: _darkAppColors.black,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: _darkAppColors.primary,
            side: BorderSide(color: _darkAppColors.primary, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            textStyle: AppTypography.dark.button.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: _darkAppColors.surfaceLight,
          labelStyle: AppTypography.dark.labelLarge.copyWith(
            color: _darkAppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide.none,
          ),
          side: BorderSide.none,
          selectedColor: _darkAppColors.primary,
        ),
        scaffoldBackgroundColor: _darkAppColors.background,
        iconTheme: IconThemeData(color: _darkAppColors.textPrimary),
      );

  static const _darkAppColors = AppColors(
    primary: Color(0xFF1ED760),
    primary50: Color(0xFF0A2E1C),
    primary100: Color(0xFF0D3D25),
    primary200: Color(0xFF115D34),
    primary300: Color(0xFF158244),
    primary400: Color(0xFF19A756),
    primary500: Color(0xFF1DB954),
    primary600: Color(0xFF1ED760),
    primary800: Color(0xFF4FE584),
    primary900: Color(0xFF7EEAA1),
    primary950: Color(0xFFA5F3BE),

    secondary: Color(0xFFCECECE),
    secondaryShade1: Color(0xFF1A1A1A),
    secondaryShade2: Color(0xFF282828),
    secondaryShade3: Color(0xFF3E3E3E),
    secondaryShade4: Color(0xFF535353),
    secondaryShade5: Color(0xFF6A6A6A),
    secondaryTint1: Color(0xFF808080),
    secondaryTint2: Color(0xFF9B9B9B),
    secondaryTint3: Color(0xFFB3B3B3),
    secondaryTint4: Color(0xFFCECECE),
    secondaryTint5: Color(0xFFE0E0E0),

    // Neutral
    white: Color(0xFFFFFFFF),
    black: Color(0xFF000000),
    background: Color(0xFF000000),
    // Spotify dark background
    surfaceLight: Color(0xFF181818),
    // Spotify card background
    surfaceDark: Color(0xFF000000),

    // Text
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFB3B3B3),
    // Spotify secondary
    textTertiary: Color(0xFF6A6A6A),
    text4: Color(0xFF535353),
    text5: Color(0xFF3E3E3E),
    // Border
    border: Color(0xFF282828),
    borderLight: Color(0xFF3E3E3E),
    activeBorder: Color(0xFF1DB954),
    inActiveBorder: Color(0xFF535353),

    // Accent
    card: Color(0xFF181818),
    accent2: Color(0xFF2A2A2A),
    accent3: Color(0xFF3E3E3E),

    // Legacy
    gray: Color(0xFF282828),
    gray2: Color(0xFF3E3E3E),
    gray4: Color(0xFF535353),

    // Graphic
    brown: Color(0xFF82422B),
    brownLight: Color(0xFF944F32),
    brownExtraLight: Color(0xFFFFCC99),

    // Status
    activeStatus: Color(0xFF1DB954),
    inActiveStatus: Color(0xFF535353),
    error: Color(0xFFE22134),
    // Spotify error red
    errorLight: Color(0xFFFF6B7A),
    errorExtraLight: Color(0xFFFFB3BA),
    success: Color(0xFF1DB954),
    successLight: Color(0xFF1ED760),
    warning: Color(0xFFFFA726),
    warningLight: Color(0xFFFFCA28),
  );
}

extension ColorThemeExtension on ThemeData {
  AppColors get appColors => extension<AppColors>()!;
}

extension FontThemeExtension on ThemeData {
  AppTypography get appTypography => extension<AppTypography>()!;
}

extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);
}

extension GradientThemeExtension on ThemeData {
  AppGradients get appGradients => extension<AppGradients>()!;
}
