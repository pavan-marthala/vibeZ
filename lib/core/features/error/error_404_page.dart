
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/routes/app_routes.dart';
import 'package:music/core/theme/app_colors.dart';
import 'package:music/core/theme/app_theme.dart';

class Error404Page extends StatefulWidget {
  const Error404Page({super.key});

  @override
  State<Error404Page> createState() => _Error404PageState();
}

class _Error404PageState extends State<Error404Page>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // Animated background gradient circles
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Positioned(
                  top: size.height * (0.2 + index * 0.15) +
                      math.sin(_rotationController.value * 2 * math.pi + index) * 50,
                  left: size.width * (0.1 + index * 0.3) +
                      math.cos(_rotationController.value * 2 * math.pi + index) * 50,
                  child: Container(
                    width: 200 - index * 40,
                    height: 200 - index * 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          colors.primary.withValues(alpha: 0.1),
                          colors.primary.withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated vinyl record with 404
                    _AnimatedVinyl404(
                      rotationController: _rotationController,
                      pulseController: _pulseController,
                      colors: colors,
                    ),

                    const SizedBox(height: 48),

                    // Slide in animation for text
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _slideController,
                        curve: Curves.easeOutCubic,
                      )),
                      child: FadeTransition(
                        opacity: _slideController,
                        child: Column(
                          children: [
                            // Title
                            Text(
                              'Track Not Found',
                              style: context.theme.appTypography.headlineLarge.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            // Subtitle
                            Text(
                              'Looks like this page hit a wrong note.\nLet\'s get you back to the music.',
                              style: context.theme.appTypography.bodyLarge.copyWith(
                                color: colors.textSecondary,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 48),

                            // Action buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Go back button
                                _GlassButton(
                                  onPressed: () => context.pop(),
                                  icon: Icons.arrow_back,
                                  label: 'Go Back',
                                  colors: colors,
                                  isPrimary: false,
                                ),
                                const SizedBox(width: 16),
                                // Home button
                                _GlassButton(
                                  onPressed: () => context.go(AppRoutes.home),
                                  icon: Icons.home_rounded,
                                  label: 'Home',
                                  colors: colors,
                                  isPrimary: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Floating music notes animation
                    SizedBox(
                      height: 100,
                      child: _FloatingMusicNotes(
                        rotationController: _rotationController,
                        colors: colors,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Animated Vinyl Record with 404
class _AnimatedVinyl404 extends StatelessWidget {
  final AnimationController rotationController;
  final AnimationController pulseController;
  final AppColors colors;

  const _AnimatedVinyl404({
    required this.rotationController,
    required this.pulseController,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([rotationController, pulseController]),
      builder: (context, child) {
        final scale = 1.0 + (pulseController.value * 0.05);

        return Transform.scale(
          scale: scale,
          child: RotationTransition(
            turns: rotationController,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colors.background,
                    colors.surfaceLight,
                    colors.background,
                    colors.surfaceLight,
                  ],
                  stops: const [0.0, 0.4, 0.6, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Vinyl grooves
                  ...List.generate(8, (index) {
                    final size = 240.0 - (index * 25);
                    return Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.border.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                    );
                  }),

                  // Center label
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colors.primary.withValues(alpha: 0.9),
                          colors.primary.withValues(alpha: 0.7),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: RotationTransition(
                        turns: Tween<double>(begin: 1.0, end: 0.0)
                            .animate(rotationController),
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: [
                                colors.white,
                                colors.white.withValues(alpha: 0.8),
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            '404',
                            style: context.theme.appTypography.displayLarge.copyWith(
                              color: colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 48,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Hole in center
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.background,
                      border: Border.all(
                        color: colors.border,
                        width: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Glass morphism button
class _GlassButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final AppColors colors;
  final bool isPrimary;

  const _GlassButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.colors,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            gradient: isPrimary
                ? LinearGradient(
                    colors: [
                      colors.primary,
                      colors.primary.withValues(alpha: 0.8),
                    ],
                  )
                : null,
            color: isPrimary ? null : colors.surfaceLight,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isPrimary
                  ? colors.primary.withValues(alpha: 0.3)
                  : colors.border,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isPrimary
                    ? colors.primary.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isPrimary ? colors.white : colors.textPrimary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: context.theme.appTypography.button.copyWith(
                  color: isPrimary ? colors.white : colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Floating music notes
class _FloatingMusicNotes extends StatelessWidget {
  final AnimationController rotationController;
  final AppColors colors;

  const _FloatingMusicNotes({
    required this.rotationController,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(5, (index) {
        return AnimatedBuilder(
          animation: rotationController,
          builder: (context, child) {
            final offset = rotationController.value + (index * 0.2);
            final yPos = math.sin(offset * 2 * math.pi) * 30;
            final opacity = (math.sin(offset * 2 * math.pi) + 1) / 2;

            return Positioned(
              left: (index * 60.0) + 20,
              top: 50 + yPos,
              child: Opacity(
                opacity: opacity * 0.6,
                child: Icon(
                  index.isEven ? Icons.music_note : Icons.music_note_outlined,
                  color: colors.primary,
                  size: 24 + (index * 4),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}