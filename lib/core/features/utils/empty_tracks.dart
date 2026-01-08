import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music/core/features/utils/app_utils.dart';
import 'package:music/core/features/utils/sized_context.dart';
import 'package:music/core/theme/app_theme.dart';
import 'dart:math' as math;

import 'package:music/generated/assets.dart';

class NoMusicFoundState extends StatelessWidget {
  final VoidCallback onAddFolder;

  const NoMusicFoundState({super.key, required this.onAddFolder});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final typography = context.theme.appTypography;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 32.0, bottom: context.viewInsets.bottom+160),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              Assets.lottieEmptyFolder,
              decoder: customDecoder,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),

            Text(
              'No Music Files Found',
              textAlign: TextAlign.center,
              style: typography.headlineMedium.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'We couldn\'t find any music files in your selected folders',
              textAlign: TextAlign.center,
              style: typography.bodyLarge.copyWith(
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // Tips Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        size: 20,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tips',
                        style: typography.titleMedium.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _TipItem(
                    text: 'Make sure your folders contain audio files',
                    colors: colors,
                    typography: typography,
                  ),
                  _TipItem(
                    text: 'Supported formats: MP3, FLAC, WAV, AAC',
                    colors: colors,
                    typography: typography,
                  ),
                  _TipItem(
                    text: 'Try adding more folders with music',
                    colors: colors,
                    typography: typography,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            PremiumButton(
              onPressed: onAddFolder,
              text: 'Add More Folders',
              icon: Icons.create_new_folder_rounded,
              color: colors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

// Animated Icon Container
class AnimatedIconContainer extends StatefulWidget {
  final IconData icon;
  final Color color;
  final Widget? illustration;

  const AnimatedIconContainer({
    super.key,
    required this.icon,
    required this.color,
    this.illustration,
  });

  @override
  State<AnimatedIconContainer> createState() => _AnimatedIconContainerState();
}

class _AnimatedIconContainerState extends State<AnimatedIconContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Rotating outer ring
            Transform.rotate(
              angle: _controller.value * 2 * math.pi,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.color.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
              ),
            ),

            // Pulsing middle ring
            Transform.scale(
              scale: 1.0 + (math.sin(_controller.value * 2 * math.pi) * 0.05),
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.color.withValues(alpha: 0.1),
                      widget.color.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Icon container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color.withValues(alpha: 0.2),
                    widget.color.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child:
                  widget.illustration ??
                  Icon(widget.icon, size: 50, color: widget.color),
            ),
          ],
        );
      },
    );
  }
}

// Premium Button Widget
class PremiumButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final Color color;

  const PremiumButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.color, widget.color.withValues(alpha: 0.8)],
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: colors.black, size: 20),
              const SizedBox(width: 8),
              Text(
                widget.text,
                style: TextStyle(
                  color: colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tip Item Widget
class _TipItem extends StatelessWidget {
  final String text;
  final dynamic colors;
  final dynamic typography;

  const _TipItem({
    required this.text,
    required this.colors,
    required this.typography,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: typography.bodyMedium.copyWith(
                color: colors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
