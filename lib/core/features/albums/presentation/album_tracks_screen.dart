import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/models/album.dart';
import 'package:music/core/features/utils/app_haptics.dart';
import 'package:music/core/theme/app_theme.dart';

class AlbumTracksScreen extends StatelessWidget {
  final Album album;

  const AlbumTracksScreen({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: colors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (album.albumArtPath != null)
                    Image.file(File(album.albumArtPath!), fit: BoxFit.cover)
                  else
                    Container(
                      color: colors.surfaceDark,
                      child: Icon(
                        Icons.album,
                        size: 100,
                        color: colors.primary,
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colors.background.withOpacity(0.1),
                          colors.background.withOpacity(0.8),
                          colors.background,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          album.name,
                          style: context.theme.appTypography.headlineMedium
                              .copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          album.artist,
                          style: context.theme.appTypography.titleMedium
                              .copyWith(color: colors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${album.trackCount} Songs • ${_formatDuration(album.totalDuration)}',
                          style: context.theme.appTypography.bodySmall.copyWith(
                            color: colors.textSecondary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.background.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () {
                AppHaptics.tap();
                Navigator.pop(context);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        AppHaptics.tap();
                        context.read<AudioPlayerBloc>().add(
                          PlayTrack(album.tracks.first, album.tracks),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play All'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        AppHaptics.tap();
                        // Implement shuffle if needed, or mapped to Play with shuffle logic
                        context.read<AudioPlayerBloc>().add(
                          PlayTrack(
                            album.tracks.first,
                            [...album.tracks]..shuffle(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shuffle),
                      label: const Text('Shuffle'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.primary,
                        side: BorderSide(color: colors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final track = album.tracks[index];
              return ListTile(
                leading: Text(
                  '${index + 1}',
                  style: context.theme.appTypography.bodyMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                title: Text(
                  track.title,
                  style: context.theme.appTypography.bodyLarge.copyWith(
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  track.artist,
                  style: context.theme.appTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                trailing: Text(
                  _formatTrackDuration(track.duration),
                  style: context.theme.appTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                onTap: () {
                  AppHaptics.tap();
                  context.read<AudioPlayerBloc>().add(
                    PlayTrack(track, album.tracks),
                  );
                },
              );
            }, childCount: album.tracks.length),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    }
    return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
  }

  String _formatTrackDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inMinutes}:$twoDigitSeconds";
  }
}
