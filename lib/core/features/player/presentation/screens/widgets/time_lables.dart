import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/utils/app_utils.dart';

class TimeLabels extends StatelessWidget {
  const TimeLabels({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      AudioPlayerBloc,
      AudioPlayerState,
      ({Duration pos, Duration dur})
    >(
      selector: (state) => (pos: state.position, dur: state.duration),
      builder: (_, data) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatDuration(data.dur),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              formatDuration(data.pos),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        );
      },
    );
  }
}
