import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:music/core/features/utils/empty_tracks.dart';
import 'package:music/core/theme/app_theme.dart';

class ErrorState extends StatefulWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onRetry;
  final IconData? icon;

  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    required this.message,
    this.buttonText = 'Try Again',
    required this.onRetry,
    this.icon,
  });

  @override
  State<ErrorState> createState() => _ErrorStateState();
}

class _ErrorStateState extends State<ErrorState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final typography = context.theme.appTypography;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon with Animation
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    math.sin(_shakeAnimation.value * math.pi * 3) * 10,
                    0,
                  ),
                  child: child,
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.error.withValues(alpha: 0.2),
                      colors.error.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.error.withValues(alpha: 0.15),
                    ),
                    child: Icon(
                      widget.icon ?? Icons.error_outline_rounded,
                      size: 56,
                      color: colors.error,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: typography.headlineMedium.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Error Message
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: colors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors.error.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: typography.bodyMedium.copyWith(
                  color: colors.errorLight,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Retry Button
            PremiumButton(
              onPressed: widget.onRetry,
              text: widget.buttonText,
              icon: Icons.refresh_rounded,
              color: colors.error,
            ),
          ],
        ),
      ),
    );
  }
}
