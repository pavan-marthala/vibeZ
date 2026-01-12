import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/player/presentation/screens/widgets/player_controls.dart';
import 'package:music/core/features/player/presentation/screens/widgets/player_header.dart';
import 'package:music/core/features/player/presentation/screens/widgets/progress_bar.dart';
import 'package:music/core/features/player/presentation/screens/widgets/time_lables.dart';
import 'package:music/core/features/player/presentation/screens/widgets/track_info.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:music/core/features/utils/app_utils.dart';
import 'package:music/core/features/utils/sized_context.dart';

class PlayerBody extends StatelessWidget {
  const PlayerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      AudioPlayerBloc,
      AudioPlayerState,
      ({AudioTrack? track, bool isPlaying, int currentIndex, int queueLength})
    >(
      selector: (state) {
        return (
          track: state.current,
          isPlaying: state.isPlaying,
          currentIndex: state.currentIndex,
          queueLength: state.queue.length,
        );
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              PlayerHeader(
                title: state.track?.title ?? 'Unknown Track',
                track: state.track,
              ),
              SizedBox(height: 24),
              Hero(
                tag: 'album-art-${state.track?.id}',
                child: Builder(
                  builder: (context) {
                    Widget art = Container(
                      width: double.infinity,
                      height: context.heightPx * 0.4,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: buildAlbumArt(state.track!, borderRadius: 12),
                    );

                    if (state.isPlaying) {
                      return art
                          .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                          .scaleXY(
                            end: 1.06,
                            duration: 300.ms,
                            curve: Curves.easeInOut,
                          );
                    }
                    return art;
                  },
                ),
              ),
              SizedBox(height: 24),
              TrackInfo(track: state.track),
              SizedBox(height: 12),
              ProgressBar(),
              TimeLabels(),
              SizedBox(height: 24),
              PlayerControls(),
              SizedBox(height: 24),
              VolumeSlider(),
            ],
          ),
        );
      },
    );
  }
}

class VolumeSlider extends StatelessWidget {
  const VolumeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    return BlocSelector<AudioPlayerBloc, AudioPlayerState, double>(
      selector: (state) => state.volume,
      builder: (context, volume) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.volume_mute_rounded,
                color: colors.secondaryTint1,
                size: 20,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 14,
                    ),
                    activeTrackColor: colors.primary,
                    inactiveTrackColor: colors.secondary.withValues(alpha: 0.3),
                    thumbColor: colors.primary,
                    overlayColor: colors.primary.withValues(alpha: 0.2),
                  ),
                  child: Slider(
                    value: volume,
                    onChanged: (value) {
                      context.read<AudioPlayerBloc>().add(SetVolume(value));
                    },
                  ),
                ),
              ),
              Icon(
                Icons.volume_up_rounded,
                color: colors.secondaryTint1,
                size: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
