import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/database/database_helper.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/bloc/music_library/music_library_bloc.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:music/core/features/shared/models/listening_stats.dart';
import 'package:music/core/features/utils/loading_widget.dart';
import 'package:music/core/theme/app_theme.dart';
import 'dart:io';

class TopTracks extends StatefulWidget {
  const TopTracks({super.key});

  @override
  State<TopTracks> createState() => _TopTracksState();
}

class _TopTracksState extends State<TopTracks> {
  late Future<List<TrackStats>> _topTracksFuture;

  @override
  void initState() {
    super.initState();
    _topTracksFuture = DatabaseHelper.instance.getTopTracks(limit: 50);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Top Tracks'),
        backgroundColor: colors.background,
        elevation: 0,
      ),
      body: BlocBuilder<MusicLibraryBloc, MusicLibraryState>(
        builder: (context, libraryState) {
          return FutureBuilder<List<TrackStats>>(
            future: _topTracksFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget(message: "Calculating top tracks...");
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading stats',
                    style: TextStyle(color: colors.error),
                  ),
                );
              }

              final tracks = snapshot.data ?? [];

              if (tracks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.equalizer,
                        size: 64,
                        color: colors.textSecondary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No stats available yet',
                        style: context.theme.appTypography.titleMedium.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Play some music to see your top tracks!',
                        style: context.theme.appTypography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: tracks.length,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 100,
                ),
                itemBuilder: (context, index) {
                  final trackStats = tracks[index];
                  
                  return Builder(
                    builder: (context) {
                       // Check playing state
                      final isPlaying = context.select<AudioPlayerBloc, bool>((bloc) {
                         final state = bloc.state;
                         return state.isPlaying && state.current?.id == trackStats.trackId;
                      });

                      return ListTile(
                        leading: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: trackStats.albumArtPath != null
                                  ? Image.file(
                                      File(trackStats.albumArtPath!),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _buildDefaultArt(colors),
                                    )
                                  : _buildDefaultArt(colors),
                            ),
                            if (index < 3)
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          trackStats.title,
                          style: context.theme.appTypography.bodyLarge.copyWith(
                            color: isPlaying ? colors.primary : colors.textPrimary,
                            fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${trackStats.artist} • ${trackStats.playCount} plays',
                          style: context.theme.appTypography.bodySmall.copyWith(
                            color: colors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatDuration(Duration(seconds: trackStats.totalPlayTime)), // Assuming seconds
                              style: context.theme.appTypography.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                             if (libraryState is MusicLibraryLoaded)
                               IconButton(
                                icon: Icon(
                                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                                  color: colors.primary,
                                ),
                                onPressed: () => _playTrack(context, trackStats, libraryState.tracks),
                               ),
                          ],
                        ),
                        onTap: () {
                            if (libraryState is MusicLibraryLoaded) {
                               _playTrack(context, trackStats, libraryState.tracks);
                            }
                        },
                      );
                    }
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _playTrack(BuildContext context, TrackStats item, List<AudioTrack> allTracks) {
    try {
      final track = allTracks.firstWhere((t) => t.id == item.trackId);
      log("track $track");
      context.read<AudioPlayerBloc>().add(
        PlayTrack(track, allTracks),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Track not found in library')),
      );
    }
  }

  Widget _buildDefaultArt(dynamic colors) {
    return Container(
      width: 50,
      height: 50,
      color: (colors as dynamic).surfaceLight,
      child: Icon(Icons.music_note, color: (colors as dynamic).primary),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    }
    return '${duration.inMinutes}m';
  }
}
