import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/database/database_helper.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/bloc/music_library/music_library_bloc.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:music/core/features/shared/models/playlist.dart';

import 'package:music/core/features/utils/loading_widget.dart';
import 'package:music/core/theme/app_theme.dart';

class PlaylistTracksScreen extends StatefulWidget {
  final Playlist? playlist;

  const PlaylistTracksScreen({super.key, required this.playlist});

  @override
  State<PlaylistTracksScreen> createState() => _PlaylistTracksScreenState();
}

class _PlaylistTracksScreenState extends State<PlaylistTracksScreen> {
  // Using Future to fetch track IDs
  late Future<List<String>> _trackIdsFuture;

  @override
  void initState() {
    super.initState();
    if (widget.playlist != null) {
      _trackIdsFuture =
          DatabaseHelper.instance.getPlaylistTrackIds(widget.playlist!.id!);
    } else {
       // Should not happen if routing is correct, but safe fallback
       _trackIdsFuture = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.playlist == null) {
      return const Scaffold(
        body: Center(child: Text('Playlist not found')),
      );
    }
    
    final playlist = widget.playlist!;
    final colors = context.theme.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text(playlist.name),
        centerTitle: true,
      ),
      body: BlocBuilder<MusicLibraryBloc, MusicLibraryState>(
        builder: (context, libraryState) {
          if (libraryState is! MusicLibraryLoaded) {
             // If library not loaded, we can't show tracks even if we have IDs
             return const LoadingWidget(message: "Loading library...");
          }

          return FutureBuilder<List<String>>(
            future: _trackIdsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget(message: "Loading playlist tracks...");
              }
              
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final trackIds = snapshot.data ?? [];
              
              // Filter logic
              // O(N*M) - naive. Better O(N) by map.
              final allTracksMap = {for (var t in libraryState.tracks) t.id: t};
              final playlistTracks = <AudioTrack>[];
              
              for (var id in trackIds) {
                if (allTracksMap.containsKey(id)) {
                  playlistTracks.add(allTracksMap[id]!);
                }
              }

              if (playlistTracks.isEmpty) {
                 return const Center(child: Text("No tracks in this playlist"));
              }

              return Column(
                children: [
                   // Play Actions
                   Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                               context.read<AudioPlayerBloc>().add(
                                    PlayTrack(playlistTracks.first, playlistTracks),
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
                               context.read<AudioPlayerBloc>().add(
                                    PlayTrack(playlistTracks.first, [...playlistTracks]..shuffle()),
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: playlistTracks.length,
                      itemBuilder: (context, index) {
                        final track = playlistTracks[index];
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
                             context.read<AudioPlayerBloc>().add(
                                  PlayTrack(track, playlistTracks),
                                );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  String _formatTrackDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inMinutes}:$twoDigitSeconds";
  }
}
