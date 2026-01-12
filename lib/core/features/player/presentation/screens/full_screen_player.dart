import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/features/player/presentation/screens/widgets/player_body.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:music/core/features/utils/app_haptics.dart';

class FullScreenPlayer extends StatelessWidget {
  const FullScreenPlayer({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Dismissible(
        key: const Key('full_screen_player_dismiss'),
        direction: DismissDirection.down,
        onDismissed: (_) {
          AppHaptics.tap();
          context.pop();
        },
        child: Stack(
          children: [
            BlocSelector<AudioPlayerBloc, AudioPlayerState, AudioTrack?>(
              selector: (s) => s.current,
              builder: (_, track) {
                return PlayerAmbientBackground(
                  colors: track?.ambientColors ?? [],
                );
              },
            ),
            // BackdropFilter(
            //   filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            //   child: Container(color: Colors.transparent),
            // ),
            SafeArea(child: const PlayerBody()),
          ],
        ),
      ),
    );
  }
}

class PlayerAmbientBackground extends StatelessWidget {
  final List<Color> colors;

  const PlayerAmbientBackground({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) {
      return const SizedBox.expand(child: ColoredBox(color: Colors.black));
    }

    return Stack(
      children: [
        Container(color: Colors.black),

        _blob(colors[0], Alignment.topLeft),
        if (colors.length > 1) _blob(colors[1], Alignment.bottomRight),
        if (colors.length > 2) _blob(colors[2], Alignment.center),
        if (colors.length > 3) _blob(colors[3], Alignment.topRight),

        Container(color: Colors.black.withOpacity(0.25)),
      ],
    );
  }

  Widget _blob(Color c, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 220, sigmaY: 220),
        child: Container(
          width: 700,
          height: 700,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c.withOpacity(0.45),
          ),
        ),
      ),
    );
  }
}
