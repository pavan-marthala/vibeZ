import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:music/core/features/utils/app_utils.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key, this.onTap});
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return BlocSelector<AudioPlayerBloc, AudioPlayerState, bool>(
      selector: (state) => state.current != null,
      builder: (context, hasTrack) {
        if (!hasTrack) return const SizedBox.shrink();
        return _MiniPlayerBody(onTap);
      },
    );
  }
}

class _MiniPlayerBody extends StatelessWidget {
  const _MiniPlayerBody(this.onTap);
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: GestureDetector(
              onTap: onTap,
              // Swipe down to dismiss/minimize
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! > 300) {
                  context.read<AudioPlayerBloc>().add(StopTrack());
                }
              },
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Stack(
                  children: [_MiniProgressBar(), _MiniControls()],
                ),
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
      builder: (context, data) {
        final progress = data.dur.inMilliseconds > 0
            ? data.pos.inMilliseconds / data.dur.inMilliseconds
            : 0.0;

        return Positioned.fill(
          child: GestureDetector(
            // Tap to seek
            onTapDown: (details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final tapPosition = details.localPosition.dx / box.size.width;
              final seekPosition = data.dur * tapPosition;
              context.read<AudioPlayerBloc>().add(SeekTrack(seekPosition));
            },
            // Drag to seek
            onHorizontalDragUpdate: (details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final dragPosition = details.localPosition.dx / box.size.width;
              final seekPosition = data.dur * dragPosition.clamp(0.0, 1.0);
              context.read<AudioPlayerBloc>().add(SeekTrack(seekPosition));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(40),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(40),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(40),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
      builder: (context, data) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Hero(
                tag: 'album-art-${data.track.id}',
                child: Container(
                  width: 56,
                  height: 56,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: buildAlbumArt(data.track, borderRadius: 28),
                ),
              ),
              const SizedBox(width: 12),

              // Track Info
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.track.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.track.artist,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Controls
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Previous Button
                  _ControlButton(
                    icon: Icons.skip_previous_rounded,
                    size: 28,
                    enabled: data.currentIndex > 0,
                    onTap: data.currentIndex > 0
                        ? () => context.read<AudioPlayerBloc>().add(
                            PreviousTrack(),
                          )
                        : null,
                  ),
                  const SizedBox(width: 4),

                  // Play/Pause Button
                  GestureDetector(
                    onTap: () {
                      context.read<AudioPlayerBloc>().add(
                        data.isPlaying ? PauseTrack() : ResumeTrack(),
                      );
                    },
                    // Double tap to skip forward 10 seconds
                    onDoubleTap: () {
                      final bloc = context.read<AudioPlayerBloc>();
                      final newPosition =
                          bloc.state.position + const Duration(seconds: 10);
                      bloc.add(SeekTrack(newPosition));
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        data.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),

                  // Next Button
                  _ControlButton(
                    icon: Icons.skip_next_rounded,
                    size: 28,
                    enabled: data.currentIndex < data.queueLength - 1,
                    onTap: data.currentIndex < data.queueLength - 1
                        ? () => context.read<AudioPlayerBloc>().add(NextTrack())
                        : null,
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final bool enabled;
  final VoidCallback? onTap;

  const _ControlButton({
    required this.icon,
    required this.size,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: size,
          color: enabled ? Colors.white : Colors.white.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
