import 'package:flutter/material.dart';

@immutable
class AppGradients extends ThemeExtension<AppGradients> {
  final LinearGradient primary;
  final LinearGradient primaryReverse;
  final LinearGradient primaryVertical;
  final LinearGradient secondary;
  final LinearGradient secondaryReverse;
  final LinearGradient rainbow;
  final LinearGradient rainbowReverse;
  final LinearGradient rainbowVertical;
  final LinearGradient purplePink;
  final LinearGradient pinkPurple;
  final LinearGradient purpleBlue;
  final LinearGradient pinkAmber;
  final LinearGradient backgroundDark;
  final LinearGradient backgroundLight;
  final LinearGradient surface;
  final LinearGradient overlay;
  final LinearGradient overlayBottom;
  final LinearGradient overlayTop;
  final LinearGradient shimmer;

  const AppGradients({
    required this.primary,
    required this.primaryReverse,
    required this.primaryVertical,
    required this.secondary,
    required this.secondaryReverse,
    required this.rainbow,
    required this.rainbowReverse,
    required this.rainbowVertical,
    required this.purplePink,
    required this.pinkPurple,
    required this.purpleBlue,
    required this.pinkAmber,
    required this.backgroundDark,
    required this.backgroundLight,
    required this.surface,
    required this.overlay,
    required this.overlayBottom,
    required this.overlayTop,
    required this.shimmer,
  });

  @override
  ThemeExtension<AppGradients> copyWith({
    LinearGradient? primary,
    LinearGradient? primaryReverse,
    LinearGradient? primaryVertical,
    LinearGradient? secondary,
    LinearGradient? secondaryReverse,
    LinearGradient? rainbow,
    LinearGradient? rainbowReverse,
    LinearGradient? rainbowVertical,
    LinearGradient? purplePink,
    LinearGradient? pinkPurple,
    LinearGradient? purpleBlue,
    LinearGradient? pinkAmber,
    LinearGradient? backgroundDark,
    LinearGradient? backgroundLight,
    LinearGradient? surface,
    LinearGradient? overlay,
    LinearGradient? overlayBottom,
    LinearGradient? overlayTop,
    LinearGradient? shimmer,
  }) {
    return AppGradients(
      primary: primary ?? this.primary,
      primaryReverse: primaryReverse ?? this.primaryReverse,
      primaryVertical: primaryVertical ?? this.primaryVertical,
      secondary: secondary ?? this.secondary,
      secondaryReverse: secondaryReverse ?? this.secondaryReverse,
      rainbow: rainbow ?? this.rainbow,
      rainbowReverse: rainbowReverse ?? this.rainbowReverse,
      rainbowVertical: rainbowVertical ?? this.rainbowVertical,
      purplePink: purplePink ?? this.purplePink,
      pinkPurple: pinkPurple ?? this.pinkPurple,
      purpleBlue: purpleBlue ?? this.purpleBlue,
      pinkAmber: pinkAmber ?? this.pinkAmber,
      backgroundDark: backgroundDark ?? this.backgroundDark,
      backgroundLight: backgroundLight ?? this.backgroundLight,
      surface: surface ?? this.surface,
      overlay: overlay ?? this.overlay,
      overlayBottom: overlayBottom ?? this.overlayBottom,
      overlayTop: overlayTop ?? this.overlayTop,
      shimmer: shimmer ?? this.shimmer,
    );
  }

  @override
  ThemeExtension<AppGradients> lerp(
    covariant ThemeExtension<AppGradients>? other,
    double t,
  ) {
    if (other is! AppGradients) return this;
    return AppGradients(
      primary: LinearGradient.lerp(primary, other.primary, t)!,
      primaryReverse: LinearGradient.lerp(
        primaryReverse,
        other.primaryReverse,
        t,
      )!,
      primaryVertical: LinearGradient.lerp(
        primaryVertical,
        other.primaryVertical,
        t,
      )!,
      secondary: LinearGradient.lerp(secondary, other.secondary, t)!,
      secondaryReverse: LinearGradient.lerp(
        secondaryReverse,
        other.secondaryReverse,
        t,
      )!,
      rainbow: LinearGradient.lerp(rainbow, other.rainbow, t)!,
      rainbowReverse: LinearGradient.lerp(
        rainbowReverse,
        other.rainbowReverse,
        t,
      )!,
      rainbowVertical: LinearGradient.lerp(
        rainbowVertical,
        other.rainbowVertical,
        t,
      )!,
      purplePink: LinearGradient.lerp(purplePink, other.purplePink, t)!,
      pinkPurple: LinearGradient.lerp(pinkPurple, other.pinkPurple, t)!,
      purpleBlue: LinearGradient.lerp(purpleBlue, other.purpleBlue, t)!,
      pinkAmber: LinearGradient.lerp(pinkAmber, other.pinkAmber, t)!,
      backgroundDark: LinearGradient.lerp(
        backgroundDark,
        other.backgroundDark,
        t,
      )!,
      backgroundLight: LinearGradient.lerp(
        backgroundLight,
        other.backgroundLight,
        t,
      )!,
      surface: LinearGradient.lerp(surface, other.surface, t)!,
      overlay: LinearGradient.lerp(overlay, other.overlay, t)!,
      overlayBottom: LinearGradient.lerp(
        overlayBottom,
        other.overlayBottom,
        t,
      )!,
      overlayTop: LinearGradient.lerp(overlayTop, other.overlayTop, t)!,
      shimmer: LinearGradient.lerp(shimmer, other.shimmer, t)!,
    );
  }

  // Spotify-inspired dark theme gradients
  static const dark = AppGradients(
    // Primary gradient - Spotify Green
    primary: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF1ED760), Color(0xFF1DB954)],
    ),
    primaryReverse: LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: [Color(0xFF1ED760), Color(0xFF1DB954)],
    ),
    primaryVertical: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1ED760), Color(0xFF1DB954)],
    ),

    // Secondary gradient - Lighter green
    secondary: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF1DB954), Color(0xFF1ED760)],
    ),
    secondaryReverse: LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: [Color(0xFF1DB954), Color(0xFF1ED760)],
    ),

    // Rainbow - Green to Blue
    rainbow: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF1ED760), Color(0xFF1DB954), Color(0xFF179443)],
      stops: [0.0, 0.5, 1.0],
    ),
    rainbowReverse: LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: [Color(0xFF1ED760), Color(0xFF1DB954), Color(0xFF179443)],
      stops: [0.0, 0.5, 1.0],
    ),
    rainbowVertical: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1ED760), Color(0xFF1DB954), Color(0xFF179443)],
      stops: [0.0, 0.5, 1.0],
    ),

    // Accent combinations
    purplePink: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1DB954), Color(0xFF1ED760)],
    ),
    pinkPurple: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1ED760), Color(0xFF1DB954)],
    ),
    purpleBlue: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1DB954), Color(0xFF0D7C3A)],
    ),
    pinkAmber: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1ED760), Color(0xFF25D966)],
    ),

    // Background gradients - Dark theme
    backgroundDark: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF121212), Color(0xFF000000)],
    ),
    backgroundLight: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1A1A1A), Color(0xFF121212)],
    ),
    surface: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF181818), Color(0xFF282828)],
    ),

    // Overlay gradients
    overlay: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0x0D1DB954), Color(0x0D1ED760)],
    ),
    overlayBottom: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Color(0xB3000000)],
    ),
    overlayTop: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [Colors.transparent, Color(0xB3000000)],
    ),

    shimmer: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.transparent, Color(0x4DFFFFFF), Colors.transparent],
      stops: [0.0, 0.5, 1.0],
    ),
  );
}
