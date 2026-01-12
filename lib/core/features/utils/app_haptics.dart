import 'package:flutter/services.dart';

class AppHaptics {
  static bool enabled = true;

  static void _run(void Function() action) {
    if (enabled) action();
  }

  static void tap() => _run(HapticFeedback.lightImpact);
  static void playPause() => _run(HapticFeedback.mediumImpact);
  static void seekTick() => _run(HapticFeedback.selectionClick);
  static void seekRelease() => _run(HapticFeedback.mediumImpact);
  static void nextPrevious() => _run(HapticFeedback.selectionClick);
  static void longPress() => _run(HapticFeedback.heavyImpact);
  static void error() => _run(HapticFeedback.vibrate);
}
