import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/home/presentation/screens/widgets/track_card.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/bloc/music_library/music_library_bloc.dart';
import 'package:music/core/features/utils/sized_context.dart';

class LibraryBuilder extends StatelessWidget {
  const LibraryBuilder({super.key, required this.libraryState});
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
        return ListView.separated(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: context.viewInsets.bottom + 160,
          ),
          itemCount: libraryState.tracks.length,
          separatorBuilder: (_, _) => SizedBox(height: 8),
          itemBuilder: (_, i) {
            final track = libraryState.tracks[i];

            final bool isPlayingThisTrack = player.currentId == track.id;

            return TrackCard(
              isPlayingThisTrack: isPlayingThisTrack,
              isPlaying: player.isPlaying,
              track: track,
              onPlayPause: () {
                final bloc = context.read<AudioPlayerBloc>();

                if (isPlayingThisTrack) {
                  bloc.add(player.isPlaying ? PauseTrack() : ResumeTrack());
                } else {
                  bloc.add(PlayTrack(track, libraryState.tracks));
                }
              },
              onTap: () {
                final bloc = context.read<AudioPlayerBloc>();

                if (isPlayingThisTrack) {
                  bloc.add(player.isPlaying ? PauseTrack() : ResumeTrack());
                } else {
                  bloc.add(PlayTrack(track, libraryState.tracks));
                }
              },
            );
          },
        );
      },
    );
  }
}
