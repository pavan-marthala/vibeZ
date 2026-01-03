import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/folder_selection/bloc/folder_selection_bloc.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/bloc/music_library/music_library_bloc.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:music/core/features/shared/widgets/mini_player.dart';
import 'package:music/core/features/utils/app_utils.dart';
import 'package:music/core/features/utils/spotify_gradient_wrapper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SpotifyGradientWrapper(
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   title: const Text('vibeZ', style: TextStyle(color: Colors.white)),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.settings, color: Colors.white),
      //       onPressed: () {
      //         context.push(AppRoutes.settings);
      //       },
      //     ),
      //   ],
      // ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            BlocConsumer<FolderSelectionBloc, FolderSelectionState>(
              listener: (context, state) {
                if (state.status == FolderSelectionStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? 'An error occurred'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.status == FolderSelectionStatus.loading &&
                    state.folders.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.folders.isEmpty) {
                  return _buildEmptyState(context);
                }

                return BlocBuilder<MusicLibraryBloc, MusicLibraryState>(
                  builder: (context, libraryState) {
                    if (libraryState is MusicLibraryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (libraryState is MusicLibraryError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(libraryState.message),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<MusicLibraryBloc>().add(
                                  LoadAudioFiles(),
                                );
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (libraryState is! MusicLibraryLoaded) {
                      return const SizedBox();
                    }

                    if (libraryState.tracks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.music_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text('No music files found'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<FolderSelectionBloc>().add(
                                  AddFolder(),
                                );
                              },
                              child: const Text('Add More Folders'),
                            ),
                          ],
                        ),
                      );
                    }

                    return BlocSelector<
                      AudioPlayerBloc,
                      AudioPlayerState,
                      ({String? currentId, bool isPlaying, int index})
                    >(
                      selector: (state) => (
                        currentId: state.current?.id,
                        isPlaying: state.isPlaying,
                        index: state.currentIndex,
                      ),
                      builder: (context, player) {
                        return ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: libraryState.tracks.length,
                          separatorBuilder: (_, _) => SizedBox(height: 8),
                          itemBuilder: (_, i) {
                            final track = libraryState.tracks[i];

                            final bool isPlayingThisTrack =
                                player.currentId == track.id;

                            return _TrackCard(
                              isPlayingThisTrack: isPlayingThisTrack,
                              isPlaying: player.isPlaying,
                              track: track,
                              onPlayPause: () {
                                final bloc = context.read<AudioPlayerBloc>();

                                if (isPlayingThisTrack) {
                                  bloc.add(
                                    player.isPlaying
                                        ? PauseTrack()
                                        : ResumeTrack(),
                                  );
                                } else {
                                  bloc.add(
                                    PlayTrack(track, libraryState.tracks),
                                  );
                                }
                              },
                              onTap: () {
                                final bloc = context.read<AudioPlayerBloc>();

                                if (isPlayingThisTrack) {
                                  bloc.add(
                                    player.isPlaying
                                        ? PauseTrack()
                                        : ResumeTrack(),
                                  );
                                } else {
                                  bloc.add(
                                    PlayTrack(track, libraryState.tracks),
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
            Positioned(bottom: 0, left: 0, right: 0, child: const MiniPlayer()),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 120, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'No Folders Selected',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add folders containing your music files to get started',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.read<FolderSelectionBloc>().add(AddFolder());
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Folder'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackCard extends StatelessWidget {
  const _TrackCard({
    required this.isPlayingThisTrack,
    required this.track,
    required this.onPlayPause,
    required this.onTap,
    required this.isPlaying,
  });

  final bool isPlayingThisTrack;
  final AudioTrack track;
  final Function() onPlayPause;
  final Function() onTap;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isPlayingThisTrack ? Colors.white.withValues(alpha: 0.4) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            spacing: 6,
            children: [
              buildAlbumArt(track),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isPlayingThisTrack
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      track.artist,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isPlayingThisTrack && isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 36,
                  color: Colors.white,
                ),
                onPressed: onPlayPause,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
