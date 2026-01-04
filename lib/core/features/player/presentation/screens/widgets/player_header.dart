import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/features/utils/app_icon_button.dart';
import 'package:music/core/theme/app_theme.dart';
import 'package:music/generated/assets.dart';

class PlayerHeader extends StatelessWidget {
  const PlayerHeader({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final typography = context.theme.appTypography;
    return Row(
      mainAxisAlignment: .spaceBetween,
      spacing: 14,
      children: [
        AppIconButton(
          icon: SvgPicture.asset(Assets.svgArrowDown),
          onTap: () {
            context.pop();
          },
        ),
        Expanded(
          child: Text(
            title,
            style: typography.headlineMedium.copyWith(
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(width: 0),
      ],
    );
  }
}
