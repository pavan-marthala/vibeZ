import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/theme/app_theme.dart';

class ProgressBar extends StatefulWidget {
  const ProgressBar({super.key});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isDragging = false;
  double? _dragProgress;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSeek(BuildContext context, double position, Duration duration) {
    final seekPosition = duration * position.clamp(0.0, 1.0);
    context.read<AudioPlayerBloc>().add(SeekTrack(seekPosition));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return BlocSelector<
      AudioPlayerBloc,
      AudioPlayerState,
      ({Duration pos, Duration dur, bool isPlaying})
    >(
      selector: (state) => (
        pos: state.position,
        dur: state.duration,
        isPlaying: state.isPlaying,
      ),
      builder: (context, data) {
        final progress = data.dur.inMilliseconds > 0
            ? data.pos.inMilliseconds / data.dur.inMilliseconds
            : 0.0;

        final displayProgress = _isDragging
            ? (_dragProgress ?? progress)
            : progress;

        return GestureDetector(
          onTapDown: (details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final tapPosition = details.localPosition.dx / box.size.width;
            _handleSeek(context, tapPosition, data.dur);
          },
          onHorizontalDragStart: (details) {
            setState(() {
              _isDragging = true;
            });
          },
          onHorizontalDragUpdate: (details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final dragPosition = details.localPosition.dx / box.size.width;
            setState(() {
              _dragProgress = dragPosition.clamp(0.0, 1.0);
            });
          },
          onHorizontalDragEnd: (details) {
            if (_dragProgress != null) {
              _handleSeek(context, _dragProgress!, data.dur);
            }
            setState(() {
              _isDragging = false;
              _dragProgress = null;
            });
          },
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Stack(
              children: [
                // Background waveform
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(double.infinity, 56),
                      painter: WaveformPainter(
                        progress: displayProgress,
                        animationValue: _animationController.value,
                        isPlaying: data.isPlaying && !_isDragging,
                        primaryColor: colors.primary,
                        backgroundColor: colors.primary50,
                        accentColor: colors.primary200,
                        isDragging: _isDragging,
                      ),
                    );
                  },
                ),
                // Progress indicator dot
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment((displayProgress * 2) - 1, 0),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double progress;
  final double animationValue;
  final bool isPlaying;
  final Color primaryColor;
  final Color backgroundColor;
  final Color accentColor;
  final bool isDragging;

  WaveformPainter({
    required this.progress,
    required this.animationValue,
    required this.isPlaying,
    required this.primaryColor,
    required this.backgroundColor,
    required this.accentColor,
    required this.isDragging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const barCount = 60;
    final barWidth = size.width / barCount;
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final normalizedIndex = i / barCount;
      final xPosition = i * barWidth;

      // Generate pseudo-random but consistent heights for waveform
      final baseHeight = _generateWaveformHeight(normalizedIndex);

      // Add animation effect when playing
      double animatedHeight = baseHeight;
      if (isPlaying && !isDragging) {
        final animationOffset = (animationValue + normalizedIndex) % 1.0;
        animatedHeight =
            baseHeight * (0.7 + 0.3 * math.sin(animationOffset * math.pi * 2));
      }

      final barHeight = size.height * animatedHeight * 0.8;

      // Determine color based on progress
      final isBeforeProgress = normalizedIndex <= progress;
      final paint = Paint()
        ..color = isBeforeProgress ? primaryColor : backgroundColor
        ..strokeWidth = barWidth * 0.7
        ..strokeCap = StrokeCap.round;

      // Add glow effect for active bars
      if (isBeforeProgress && isPlaying) {
        final glowPaint = Paint()
          ..color = primaryColor.withValues(alpha: 0.3)
          ..strokeWidth = barWidth * 0.9
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

        canvas.drawLine(
          Offset(xPosition + barWidth / 2, centerY - barHeight / 2),
          Offset(xPosition + barWidth / 2, centerY + barHeight / 2),
          glowPaint,
        );
      }

      // Draw main bar
      canvas.drawLine(
        Offset(xPosition + barWidth / 2, centerY - barHeight / 2),
        Offset(xPosition + barWidth / 2, centerY + barHeight / 2),
        paint,
      );

      // Add accent highlights for played portion
      if (isBeforeProgress && i % 3 == 0) {
        final accentPaint = Paint()
          ..color = accentColor.withValues(alpha: 0.6)
          ..strokeWidth = barWidth * 0.3
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(
          Offset(xPosition + barWidth / 2, centerY - barHeight / 2),
          Offset(xPosition + barWidth / 2, centerY - barHeight / 4),
          accentPaint,
        );
      }
    }
  }

  double _generateWaveformHeight(double position) {
    // Generate realistic-looking waveform using multiple sine waves
    final wave1 = math.sin(position * math.pi * 4) * 0.3;
    final wave2 = math.sin(position * math.pi * 8 + 1) * 0.2;
    final wave3 = math.sin(position * math.pi * 16 + 2) * 0.15;
    final wave4 = math.sin(position * math.pi * 3) * 0.25;

    // Combine waves and normalize
    final combined = (wave1 + wave2 + wave3 + wave4 + 1.0) / 2.0;

    // Add some variation to make it more natural
    final variation = math.sin(position * 50) * 0.1;

    return (combined + variation).clamp(0.3, 1.0);
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.isPlaying != isPlaying ||
        oldDelegate.isDragging != isDragging;
  }
}
