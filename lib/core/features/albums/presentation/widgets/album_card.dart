import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/core/features/shared/models/album.dart';
import 'package:music/core/theme/app_theme.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({super.key, required this.album});

  final Album album;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Image.file(File(album.albumArtPath!), fit: BoxFit.cover),

          Positioned.fill(
            child: CustomPaint(
              painter: _GlassBorderPainter(radius: 8, color: colors.secondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassBorderPainter extends CustomPainter {
  final double radius;
  final Color color;

  _GlassBorderPainter({required this.radius, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(0.6),
      Radius.circular(radius),
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withValues(alpha: 0.5),
          Colors.transparent,

          color.withValues(alpha: 0.5),
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
