import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/utils/app_haptics.dart';
import 'package:music/core/theme/app_theme.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    return BlocSelector<
      AudioPlayerBloc,
      AudioPlayerState,
      ({bool isPlaying, int currentIndex, int queueLength})
    >(
      selector: (state) => (
        isPlaying: state.isPlaying,
        currentIndex: state.currentIndex,
        queueLength: state.queue.length,
      ),
      builder: (context, state) {
        final ispreviousEnabled = state.currentIndex > 0;
        final isNextEnabled = state.currentIndex < state.queueLength - 1;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ControleButton(
              icon: Icon(
                Icons.skip_previous,
                size: 28,
                color: ispreviousEnabled ? Colors.white : colors.secondaryTint1,
              ),
              enabled: ispreviousEnabled,
              onTap: ispreviousEnabled
                  ? () {
                      AppHaptics.nextPrevious();
                      context.read<AudioPlayerBloc>().add(PreviousTrack());
                    }
                  : null,
            ),
            ControleButton(
              icon: Icon(
                state.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                size: 36,
                color: Colors.black,
              ),
              size: 64,
              color: colors.primary.withValues(alpha: .8),
              onTap: () {
                AppHaptics.playPause();
                context.read<AudioPlayerBloc>().add(
                  state.isPlaying ? PauseTrack() : ResumeTrack(),
                );
              },
              enabled: true,
            ),
            ControleButton(
              icon: Icon(
                Icons.skip_next,
                color: isNextEnabled ? Colors.white : colors.secondaryTint1,
              ),
              enabled: isNextEnabled,
              onTap: isNextEnabled
                  ? () {
                      AppHaptics.nextPrevious();
                      context.read<AudioPlayerBloc>().add(NextTrack());
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }
}

class ControleButton extends StatelessWidget {
  const ControleButton({
    super.key,
    this.size = 46,
    required this.icon,
    this.color,
    this.enabled = true,
    this.onTap,
  });
  final double size;
  final Widget icon;
  final Color? color;

  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color ?? colors.secondary.withValues(alpha: .3),
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }
}
