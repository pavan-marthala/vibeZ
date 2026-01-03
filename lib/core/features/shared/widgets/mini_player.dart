import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:music/core/features/utils/app_utils.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AudioPlayerBloc, AudioPlayerState, bool>(
      selector: (state) => state.current != null,
      builder: (context, hasTrack) {
        if (!hasTrack) return const SizedBox.shrink();
        return const _MiniPlayerBody();
      },
    );
  }
}

class _MiniPlayerBody extends StatelessWidget {
  const _MiniPlayerBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Stack(
                // mainAxisSize: MainAxisSize.min,
                children: const [_MiniProgressBar(), _MiniControls()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniProgressBar extends StatelessWidget {
  const _MiniProgressBar();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      AudioPlayerBloc,
      AudioPlayerState,
      ({Duration pos, Duration dur})
    >(
      selector: (state) => (pos: state.position, dur: state.duration),
      builder: (_, data) {
        final progress = data.dur.inMilliseconds > 0
            ? data.pos.inMilliseconds / data.dur.inMilliseconds
            : 0.0;

        return SizedBox(
          height: 57,
          child: FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(color: Colors.white.withValues(alpha: 0.3)),
          ),
        );
      },
    );
  }
}

class _MiniControls extends StatelessWidget {
  const _MiniControls();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      AudioPlayerBloc,
      AudioPlayerState,
      ({AudioTrack track, bool isPlaying, int currentIndex, int queueLength})
    >(
      selector: (state) => (
        track: state.current!,
        isPlaying: state.isPlaying,
        currentIndex: state.currentIndex,
        queueLength: state.queue.length,
      ),
      builder: (_, data) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            spacing: 6,
            children: [
              buildAlbumArt(data.track, borderRadius: 50),
              Expanded(
                child: Text(
                  data.track.title,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: data.currentIndex > 0
                    ? () => context.read<AudioPlayerBloc>().add(PreviousTrack())
                    : null,
                child: Icon(Icons.skip_previous, color: Colors.white),
              ),
              GestureDetector(
                child: Icon(
                  data.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 40,
                  color: Colors.white,
                ),
                onTap: () {
                  context.read<AudioPlayerBloc>().add(
                    data.isPlaying ? PauseTrack() : ResumeTrack(),
                  );
                },
              ),
              GestureDetector(
                onTap: data.currentIndex < data.queueLength - 1
                    ? () => context.read<AudioPlayerBloc>().add(NextTrack())
                    : null,
                child: const Icon(Icons.skip_next, color: Colors.white),
              ),
              SizedBox(width: 6),
            ],
          ),
        );
      },
    );
  }
}
