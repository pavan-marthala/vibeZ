import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/bloc/music_library/music_library_bloc.dart';
import 'package:music/core/features/track/presentation/widgets/track_card.dart';
import 'package:music/core/features/utils/app_haptics.dart';
import 'package:music/core/features/utils/sized_context.dart';

class TrackBuilder extends StatelessWidget {
  const TrackBuilder({super.key, required this.libraryState});

  final MusicLibraryLoaded libraryState;

  @override
  Widget build(BuildContext context) {
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
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${libraryState.tracks.length} Tracks',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.sort_rounded),
                    onPressed: () => _showSortOptions(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 0,
                  bottom: context.viewInsets.bottom + 160,
                ),
                itemCount: libraryState.tracks.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final track = libraryState.tracks[i];

                  final bool isPlayingThisTrack = player.currentId == track.id;

                  return TrackCard(
                    isPlayingThisTrack: isPlayingThisTrack,
                    isPlaying: player.isPlaying,
                    track: track,
                    onPlayPause: () {
                      final bloc = context.read<AudioPlayerBloc>();
                      AppHaptics.playPause();
                      if (isPlayingThisTrack) {
                        bloc.add(
                          player.isPlaying ? PauseTrack() : ResumeTrack(),
                        );
                      } else {
                        bloc.add(PlayTrack(track, libraryState.tracks));
                      }
                    },
                    onTap: () {
                      final bloc = context.read<AudioPlayerBloc>();
                      AppHaptics.playPause();
                      if (isPlayingThisTrack) {
                        bloc.add(
                          player.isPlaying ? PauseTrack() : ResumeTrack(),
                        );
                      } else {
                        bloc.add(PlayTrack(track, libraryState.tracks));
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 0,
            bottom: context.viewInsets.bottom + 160,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sort By',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...SortOption.values.map((option) {
                return ListTile(
                  title: Text(_getSortOptionName(option)),
                  trailing: libraryState.sortOption == option
                      ? Icon(
                          libraryState.sortOrder == SortOrder.ascending
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                  onTap: () {
                    final newOrder =
                        libraryState.sortOption == option &&
                            libraryState.sortOrder == SortOrder.ascending
                        ? SortOrder.descending
                        : SortOrder.ascending;

                    context.read<MusicLibraryBloc>().add(
                      SortTracks(option, newOrder),
                    );
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  String _getSortOptionName(SortOption option) {
    switch (option) {
      case SortOption.title:
        return 'Name';
      case SortOption.artist:
        return 'Artist';
      case SortOption.album:
        return 'Album';
      case SortOption.year:
        return 'Year';
      case SortOption.dateAdded:
        return 'Date Added';
      case SortOption.dateModified:
        return 'Date Modified';
    }
  }
}
