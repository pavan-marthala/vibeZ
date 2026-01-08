import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/bloc/music_library/music_library_bloc.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:music/core/features/utils/loading_widget.dart';
import 'package:music/core/theme/app_theme.dart';
import 'dart:io';

class ArtistTracksScreen extends StatelessWidget {
  final String artistName;

  const ArtistTracksScreen({super.key, required this.artistName});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(artistName),
        backgroundColor: colors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<MusicLibraryBloc, MusicLibraryState>(
        builder: (context, state) {
          if (state is! MusicLibraryLoaded) {
            return const LoadingWidget(message: "Loading library...");
          }

          // Filter tracks by artist (case insensitive match might be safer)
          final artistTracks = state.tracks
              .where((t) => t.artist.toLowerCase() == artistName.toLowerCase())
              .toList()
              // Sort by album then title
              ..sort((a, b) {
                 final albumCmp = a.album.compareTo(b.album);
                 if (albumCmp != 0) return albumCmp;
                 return a.title.compareTo(b.title);
              });

          if (artistTracks.isEmpty) {
            return Center(
              child: Text(
                'No tracks found for this artist',
                style: TextStyle(color: colors.textSecondary),
              ),
            );
          }

          return Column(
            children: [
               Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                           context.read<AudioPlayerBloc>().add(
                                PlayTrack(artistTracks.first, artistTracks),
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
                                PlayTrack(artistTracks.first, [...artistTracks]..shuffle()),
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
                  itemCount: artistTracks.length,
                   padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 100,
                  ),
                  itemBuilder: (context, index) {
                    final track = artistTracks[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: track.albumArtPath != null
                            ? Image.file(
                                File(track.albumArtPath!),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _buildDefaultArt(colors),
                              )
                            : _buildDefaultArt(colors),
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
                        track.album,
                        style: context.theme.appTypography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                       trailing: Text(
                        _formatDuration(track.duration),
                        style: context.theme.appTypography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      onTap: () {
                         context.read<AudioPlayerBloc>().add(
                              PlayTrack(track, artistTracks),
                            );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
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
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inMinutes}:$twoDigitSeconds";
  }
}
