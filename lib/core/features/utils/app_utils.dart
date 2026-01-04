import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:collection/collection.dart';

Widget buildAlbumArt(AudioTrack track, {double borderRadius = 6}) {
  if (track.albumArtPath == null) {
    return const Icon(CupertinoIcons.music_note_2, size: 48);
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: Image.file(
      File(track.albumArtPath!),
      width: 52,
      height: 52,
      fit: BoxFit.cover,
    ),
  );
}

String formatDuration(Duration d) {
  final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

Future<LottieComposition?> customDecoder(List<int> bytes) {
  return LottieComposition.decodeZip(
    bytes,
    filePicker: (files) {
      return files.firstWhereOrNull(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    },
  );
}
