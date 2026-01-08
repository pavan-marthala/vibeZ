import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music/core/features/shared/models/album.dart';
import 'package:music/core/features/utils/app_utils.dart';
import 'package:music/core/theme/app_colors.dart';
import 'package:music/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/routes/app_routes.dart';
import 'package:music/core/theme/app_typography.dart';
import 'package:music/generated/assets.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({super.key, required this.album});

  final Album album;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final typography = context.theme.appTypography;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          album.albumArtPath != null
                      ? Image.file(
                          File(album.albumArtPath!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              buildDefaultArt(colors,album,typography),
                        )
                      :buildDefaultArt(colors,album,typography),
          Positioned.fill(
            child: CustomPaint(
              painter: _GlassBorderPainter(radius: 8, color: colors.secondary),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.goNamed(AppRoutes.albumTracks, extra: album);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
Widget buildDefaultArt(AppColors colors,Album album,AppTypography typography) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(8),
    color: colors.secondary.withValues(alpha: 0.2),
    child: Column(
      children: [
       SvgPicture.asset(Assets.svgAlbums,
       width: 52,
       height: 52,
       colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
       ),
       const SizedBox(height: 8),
       Text(
         album.name,
         style: typography.titleMedium,
       ),
       const SizedBox(height: 4),
       Text(
         album.artist,
         style: typography.bodySmall,
       ),
       const SizedBox(height: 4),
       Text(
         '${album.trackCount} Songs • ${formatDuration(album.totalDuration)}',
         style: typography.bodySmall,
       ),
      ],
    ),
  );
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
