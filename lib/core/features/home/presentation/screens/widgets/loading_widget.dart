import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music/core/features/utils/app_utils.dart';
import 'package:music/core/theme/app_theme.dart';
import 'package:music/generated/assets.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            Assets.lottieLoading,
            decoder: customDecoder,
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(color: colors.textPrimary, fontSize: 16),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
