import 'package:flutter/material.dart';

@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  // Display
  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;

  // Headline
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;

  // Title
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;

  // Body
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;

  // Label
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  // Custom text styles
  final TextStyle button;
  final TextStyle caption;

  const AppTypography({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.button,
    required this.caption,
  });

  @override
  ThemeExtension<AppTypography> copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    TextStyle? button,
    TextStyle? caption,
  }) {
    return AppTypography(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
      button: button ?? this.button,
      caption: caption ?? this.caption,
    );
  }

  @override
  ThemeExtension<AppTypography> lerp(
    covariant ThemeExtension<AppTypography>? other,
    double t,
  ) {
    if (other is! AppTypography) {
      return this;
    }

    return AppTypography(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t)!,
      displaySmall: TextStyle.lerp(displaySmall, other.displaySmall, t)!,
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t)!,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t)!,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
    );
  }

  static AppTypography light = AppTypography(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w600,
      height: 1.12,
      fontFamily: "Inter",
      color: Colors.black,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      height: 1.16,
      color: Colors.black,
      fontFamily: "Inter",
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: Colors.black,
      height: 1.22,
      fontFamily: "Inter",
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.25,
      color: Colors.black,
      fontFamily: "Inter",
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      height: 1.29,
      color: Colors.black,
      fontFamily: "Inter",
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      height: 1.33,
      color: Colors.black,
      fontFamily: "Inter",
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.27,
      color: Colors.black,
      fontFamily: "Inter",
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
      color: Colors.black,
      letterSpacing: 0.15,
      fontFamily: "Inter",
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.43,
      letterSpacing: 0.1,
      color: Colors.black,
      fontFamily: "Inter",
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
      letterSpacing: 0.5,
      color: Colors.black,
      fontFamily: "Inter",
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.43,
      color: Colors.black,
      letterSpacing: 0.25,
      fontFamily: "Inter",
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.33,
      color: Colors.black,
      letterSpacing: 0.4,
      fontFamily: "Inter",
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.43,
      color: Colors.black,
      letterSpacing: 0.1,
      fontFamily: "Inter",
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.33,
      color: Colors.black,
      letterSpacing: 0.5,
      fontFamily: "Inter",
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 1.45,
      color: Colors.black,
      letterSpacing: 0.5,
      fontFamily: "Inter",
    ),
    button: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.42,
      letterSpacing: 0.1,
      color: Colors.black,
      fontFamily: "Inter",
    ),
    caption: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.33,
      color: Colors.black,
      letterSpacing: 0.4,
      fontFamily: "Inter",
    ),
  );

  static AppTypography dark = AppTypography(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w600,
      height: 1.12,
      fontFamily: "Inter",
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      height: 1.16,
      color: Colors.white,
      fontFamily: "Inter",
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      height: 1.22,
      fontFamily: "Inter",
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.25,
      color: Colors.white,
      fontFamily: "Inter",
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      height: 1.29,
      color: Colors.white,
      fontFamily: "Inter",
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      height: 1.33,
      color: Colors.white,
      fontFamily: "Inter",
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.27,
      color: Colors.white,
      fontFamily: "Inter",
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
      color: Colors.white,
      letterSpacing: 0.15,
      fontFamily: "Inter",
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.43,
      letterSpacing: 0.1,
      color: Colors.white,
      fontFamily: "Inter",
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
      letterSpacing: 0.5,
      color: Colors.white,
      fontFamily: "Inter",
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.43,
      color: Colors.white,
      letterSpacing: 0.25,
      fontFamily: "Inter",
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.33,
      color: Colors.white,
      letterSpacing: 0.4,
      fontFamily: "Inter",
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.43,
      color: Colors.white,
      letterSpacing: 0.1,
      fontFamily: "Inter",
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.33,
      color: Colors.white,
      letterSpacing: 0.5,
      fontFamily: "Inter",
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 1.45,
      color: Colors.white,
      letterSpacing: 0.5,
      fontFamily: "Inter",
    ),
    button: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.42,
      letterSpacing: 0.1,
      color: Colors.white,
      fontFamily: "Inter",
    ),
    caption: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.33,
      color: Colors.white,
      letterSpacing: 0.4,
      fontFamily: "Inter",
    ),
  );
}
