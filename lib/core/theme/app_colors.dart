import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  /// Primary colors - Spotify Green
  final Color primary;
  final Color primary50;
  final Color primary100;
  final Color primary200;
  final Color primary300;
  final Color primary400;
  final Color primary500;
  final Color primary600;
  final Color primary800;
  final Color primary900;
  final Color primary950;

  /// Secondary colors - Accent variations
  final Color secondary;
  final Color secondaryShade1;
  final Color secondaryShade2;
  final Color secondaryShade3;
  final Color secondaryShade4;
  final Color secondaryShade5;
  final Color secondaryTint1;
  final Color secondaryTint2;
  final Color secondaryTint3;
  final Color secondaryTint4;
  final Color secondaryTint5;

  /// Neutral colors
  final Color white;
  final Color black;
  final Color background;
  final Color surfaceLight;
  final Color surfaceDark;

  /// Text colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color text4;
  final Color text5;

  /// Border colors
  final Color border;
  final Color borderLight;
  final Color activeBorder;
  final Color inActiveBorder;

  /// Accent colors
  final Color card;
  final Color accent2;
  final Color accent3;

  /// Legacy colors
  final Color gray;
  final Color gray2;
  final Color gray4;

  /// Graphic colors
  final Color brown;
  final Color brownLight;
  final Color brownExtraLight;

  /// Status colors
  final Color activeStatus;
  final Color inActiveStatus;
  final Color error;
  final Color errorLight;
  final Color errorExtraLight;
  final Color success;
  final Color successLight;
  final Color warning;
  final Color warningLight;

  const AppColors({
    required this.primary,
    required this.primary50,
    required this.primary100,
    required this.primary200,
    required this.primary300,
    required this.primary400,
    required this.primary500,
    required this.primary600,
    required this.primary800,
    required this.primary900,
    required this.primary950,
    required this.secondary,
    required this.secondaryShade1,
    required this.secondaryShade2,
    required this.secondaryShade3,
    required this.secondaryShade4,
    required this.secondaryShade5,
    required this.secondaryTint1,
    required this.secondaryTint2,
    required this.secondaryTint3,
    required this.secondaryTint4,
    required this.secondaryTint5,
    required this.white,
    required this.black,
    required this.background,
    required this.surfaceLight,
    required this.surfaceDark,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.text4,
    required this.text5,
    required this.border,
    required this.borderLight,
    required this.activeBorder,
    required this.inActiveBorder,
    required this.card,
    required this.accent2,
    required this.accent3,
    required this.gray,
    required this.gray2,
    required this.gray4,
    required this.brown,
    required this.brownLight,
    required this.brownExtraLight,
    required this.activeStatus,
    required this.inActiveStatus,
    required this.error,
    required this.errorLight,
    required this.errorExtraLight,
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
  });

  @override
  ThemeExtension<AppColors> copyWith({
    Color? primary,
    Color? primary50,
    Color? primary100,
    Color? primary200,
    Color? primary300,
    Color? primary400,
    Color? primary500,
    Color? primary600,
    Color? primary800,
    Color? primary900,
    Color? primary950,
    Color? secondary,
    Color? secondaryShade1,
    Color? secondaryShade2,
    Color? secondaryShade3,
    Color? secondaryShade4,
    Color? secondaryShade5,
    Color? secondaryTint1,
    Color? secondaryTint2,
    Color? secondaryTint3,
    Color? secondaryTint4,
    Color? secondaryTint5,
    Color? white,
    Color? black,
    Color? background,
    Color? surfaceLight,
    Color? surfaceDark,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? text4,
    Color? text5,
    Color? border,
    Color? borderLight,
    Color? activeBorder,
    Color? inActiveBorder,
    Color? card,
    Color? accent2,
    Color? accent3,
    Color? gray,
    Color? gray2,
    Color? gray4,
    Color? brown,
    Color? brownLight,
    Color? brownExtraLight,
    Color? error,
    Color? errorLight,
    Color? errorExtraLight,
    Color? success,
    Color? successLight,
    Color? warning,
    Color? warningLight,
    Color? activeStatus,
    Color? inActiveStatus,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primary50: primary50 ?? this.primary50,
      primary100: primary100 ?? this.primary100,
      primary200: primary200 ?? this.primary200,
      primary300: primary300 ?? this.primary300,
      primary400: primary400 ?? this.primary400,
      primary500: primary500 ?? this.primary500,
      primary600: primary600 ?? this.primary600,
      primary800: primary800 ?? this.primary800,
      primary900: primary900 ?? this.primary900,
      primary950: primary950 ?? this.primary950,
      secondary: secondary ?? this.secondary,
      secondaryShade1: secondaryShade1 ?? this.secondaryShade1,
      secondaryShade2: secondaryShade2 ?? this.secondaryShade2,
      secondaryShade3: secondaryShade3 ?? this.secondaryShade3,
      secondaryShade4: secondaryShade4 ?? this.secondaryShade4,
      secondaryShade5: secondaryShade5 ?? this.secondaryShade5,
      secondaryTint1: secondaryTint1 ?? this.secondaryTint1,
      secondaryTint2: secondaryTint2 ?? this.secondaryTint2,
      secondaryTint3: secondaryTint3 ?? this.secondaryTint3,
      secondaryTint4: secondaryTint4 ?? this.secondaryTint4,
      secondaryTint5: secondaryTint5 ?? this.secondaryTint5,
      white: white ?? this.white,
      black: black ?? this.black,
      background: background ?? this.background,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      surfaceDark: surfaceDark ?? this.surfaceDark,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      text4: text4 ?? this.text4,
      text5: text5 ?? this.text5,
      border: border ?? this.border,
      borderLight: borderLight ?? this.borderLight,
      card: card ?? this.card,
      accent2: accent2 ?? this.accent2,
      accent3: accent3 ?? this.accent3,
      gray: gray ?? this.gray,
      gray2: gray2 ?? this.gray2,
      gray4: gray4 ?? this.gray4,
      brown: brown ?? this.brown,
      brownLight: brownLight ?? this.brownLight,
      brownExtraLight: brownExtraLight ?? this.brownExtraLight,
      error: error ?? this.error,
      errorLight: errorLight ?? this.errorLight,
      errorExtraLight: errorExtraLight ?? this.errorExtraLight,
      success: success ?? this.success,
      successLight: successLight ?? this.successLight,
      warning: warning ?? this.warning,
      warningLight: warningLight ?? this.warningLight,
      activeStatus: activeStatus ?? this.activeStatus,
      inActiveStatus: inActiveStatus ?? this.inActiveStatus,
      activeBorder: activeBorder ?? this.activeBorder,
      inActiveBorder: inActiveBorder ?? this.inActiveBorder,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primary50: Color.lerp(primary50, other.primary50, t)!,
      primary100: Color.lerp(primary100, other.primary100, t)!,
      primary200: Color.lerp(primary200, other.primary200, t)!,
      primary300: Color.lerp(primary300, other.primary300, t)!,
      primary400: Color.lerp(primary400, other.primary400, t)!,
      primary500: Color.lerp(primary500, other.primary500, t)!,
      primary600: Color.lerp(primary600, other.primary600, t)!,
      primary800: Color.lerp(primary800, other.primary800, t)!,
      primary900: Color.lerp(primary900, other.primary900, t)!,
      primary950: Color.lerp(primary950, other.primary950, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryShade1: Color.lerp(secondaryShade1, other.secondaryShade1, t)!,
      secondaryShade2: Color.lerp(secondaryShade2, other.secondaryShade2, t)!,
      secondaryShade3: Color.lerp(secondaryShade3, other.secondaryShade3, t)!,
      secondaryShade4: Color.lerp(secondaryShade4, other.secondaryShade4, t)!,
      secondaryShade5: Color.lerp(secondaryShade5, other.secondaryShade5, t)!,
      secondaryTint1: Color.lerp(secondaryTint1, other.secondaryTint1, t)!,
      secondaryTint2: Color.lerp(secondaryTint2, other.secondaryTint2, t)!,
      secondaryTint3: Color.lerp(secondaryTint3, other.secondaryTint3, t)!,
      secondaryTint4: Color.lerp(secondaryTint4, other.secondaryTint4, t)!,
      secondaryTint5: Color.lerp(secondaryTint5, other.secondaryTint5, t)!,
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(black, other.black, t)!,
      background: Color.lerp(background, other.background, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      surfaceDark: Color.lerp(surfaceDark, other.surfaceDark, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      text4: Color.lerp(text4, other.text4, t)!,
      text5: Color.lerp(text5, other.text5, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      card: Color.lerp(card, other.card, t)!,
      accent2: Color.lerp(accent2, other.accent2, t)!,
      accent3: Color.lerp(accent3, other.accent3, t)!,
      gray: Color.lerp(gray, other.gray, t)!,
      gray2: Color.lerp(gray2, other.gray2, t)!,
      gray4: Color.lerp(gray4, other.gray4, t)!,
      brown: Color.lerp(brown, other.brown, t)!,
      brownLight: Color.lerp(brownLight, other.brownLight, t)!,
      brownExtraLight: Color.lerp(brownExtraLight, other.brownExtraLight, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorLight: Color.lerp(errorLight, other.errorLight, t)!,
      errorExtraLight: Color.lerp(errorExtraLight, other.errorExtraLight, t)!,
      success: Color.lerp(success, other.success, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
      activeStatus: Color.lerp(activeStatus, other.activeStatus, t)!,
      inActiveStatus: Color.lerp(inActiveStatus, other.inActiveStatus, t)!,
      activeBorder: Color.lerp(activeBorder, other.activeBorder, t)!,
      inActiveBorder: Color.lerp(inActiveBorder, other.inActiveBorder, t)!,
    );
  }
}
