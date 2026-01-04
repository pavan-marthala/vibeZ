import 'package:flutter/material.dart';
import 'package:music/core/theme/app_theme.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({super.key, this.size, this.onTap, required this.icon});
  final double? size;
  final VoidCallback? onTap;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size ?? 42,
        width: size ?? 42,
        decoration: BoxDecoration(
          color: colors.secondary.withValues(alpha: .3),
          shape: BoxShape.circle,
          border: Border.all(color: colors.secondaryTint3),
        ),
        alignment: .center,
        child: icon,
      ),
    );
  }
}
