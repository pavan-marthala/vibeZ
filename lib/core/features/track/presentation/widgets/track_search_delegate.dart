import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/bloc/music_library/music_library_bloc.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:music/core/features/track/presentation/widgets/track_card.dart';
import 'package:music/core/features/utils/app_haptics.dart';

class TrackSearchDelegate extends SearchDelegate<AudioTrack?> {
  final MusicLibraryBloc musicLibraryBloc;
  final AudioPlayerBloc audioPlayerBloc;

  TrackSearchDelegate({
    required this.musicLibraryBloc,
    required this.audioPlayerBloc,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: theme.hintColor),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    musicLibraryBloc.add(SearchAudioFiles(query));

    return BlocBuilder<MusicLibraryBloc, MusicLibraryState>(
      bloc: musicLibraryBloc,
      builder: (context, state) {
        if (state is MusicLibraryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MusicLibraryLoaded) {
          if (state.tracks.isEmpty) {
            return _buildEmptyState(context);
          }

          return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
            bloc: audioPlayerBloc,
            builder: (context, playerState) {
              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 160),
                itemCount: state.tracks.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final track = state.tracks[index];
                  final isPlayingThisTrack =
                      playerState.current?.id == track.id;

                  return TrackCard(
                    track: track,
                    isPlayingThisTrack: isPlayingThisTrack,
                    isPlaying: playerState.isPlaying,
                    onTap: () {
                      AppHaptics.tap();
                      if (isPlayingThisTrack) {
                        audioPlayerBloc.add(
                          playerState.isPlaying ? PauseTrack() : ResumeTrack(),
                        );
                      } else {
                        audioPlayerBloc.add(PlayTrack(track, state.tracks));
                      }
                      close(context, track);
                    },
                    onPlayPause: () {
                      AppHaptics.playPause();
                      if (isPlayingThisTrack) {
                        audioPlayerBloc.add(
                          playerState.isPlaying ? PauseTrack() : ResumeTrack(),
                        );
                      } else {
                        audioPlayerBloc.add(PlayTrack(track, state.tracks));
                      }
                    },
                  );
                },
              );
            },
          );
        }

        if (state is MusicLibraryError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // We can show recent searches here or just perform live search
    if (query.isEmpty) {
      return Center(
        child: Text(
          'Search your music...',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    // Live search behavior
    musicLibraryBloc.add(SearchAudioFiles(query));
    return buildResults(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 60,
            color: Theme.of(context).disabledColor,
          ),
          SizedBox(height: 16),
          Text(
            'No results found for "$query"',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
