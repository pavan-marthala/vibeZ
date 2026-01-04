import 'package:flutter/material.dart';
import 'package:music/core/theme/app_colors.dart';

class GradientBackgroundPainter extends CustomPainter {
  final AppColors colors;

  GradientBackgroundPainter({super.repaint, required this.colors});
  @override
  void paint(Canvas canvas, Size size) {
    // Base gradient
    final baseGradient = RadialGradient(
      center: const Alignment(0.0, -0.8),
      radius: 1.3,
      colors: [
        colors.primary200.withValues(alpha: 0.45),
        const Color(0xFF000000),
      ],
      stops: const [0.0, 0.5],
    );

    final basePaint = Paint()
      ..shader = baseGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), basePaint);

    // Purple blob
    final purpleGradient = RadialGradient(
      colors: [colors.primary200.withValues(alpha: 0.15), Colors.transparent],
      stops: const [0.0, 0.5],
    );

    final purplePaint = Paint()
      ..shader = purpleGradient.createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.2, size.height * 0.3),
          radius: 300,
        ),
      );

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      300,
      purplePaint,
    );

    // Blue blob
    final blueGradient = RadialGradient(
      colors: [colors.primary.withValues(alpha: .15), Colors.transparent],
      stops: const [0.0, 0.5],
    );

    final bluePaint = Paint()
      ..shader = blueGradient.createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.8, size.height * 0.7),
          radius: 350,
        ),
      );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      350,
      bluePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
