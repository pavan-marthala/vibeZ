import 'package:flutter/material.dart';
import 'package:music/core/features/player/presentation/screens/widgets/player_body.dart';
import 'package:music/core/features/utils/gradient_background_painter.dart';
import 'package:music/core/theme/app_theme.dart';

class FullScreenPlayer extends StatelessWidget {
  const FullScreenPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: GradientBackgroundPainter(colors: colors),
            child: Container(),
          ),
          SafeArea(child: PlayerBody()),
        ],
      ),
    );
  }
}
