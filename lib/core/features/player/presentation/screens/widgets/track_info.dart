import 'package:flutter/material.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:music/core/features/utils/favorite_button.dart';
import 'package:music/core/theme/app_theme.dart';

class TrackInfo extends StatelessWidget {
  const TrackInfo({super.key, this.track});
  final AudioTrack? track;
  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final typography = context.theme.appTypography;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                track?.title ?? 'Unknown Title',
                style: typography.titleMedium.copyWith(
                  color: colors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 4),
              Text(
                track?.artist ?? 'Unknown Artist',
                style: typography.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        if (track != null) ...[FavoriteButton(track: track!)],
      ],
    );
  }
}
