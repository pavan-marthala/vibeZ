import 'package:flutter/material.dart';

class SpotifyGradientWrapper extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const SpotifyGradientWrapper({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.8, -0.8),
            radius: 1.2,
            colors:
                colors ??
                [
                  const Color(0xFF1e5a3a).withOpacity(0.8),
                  const Color(0xFF0a2818).withOpacity(0.5),
                  const Color(0xFF000000),
                ],
            stops: const [0.0, 0.4, 0.8],
          ),
        ),
        child: child,
      ),
    );
  }
}
