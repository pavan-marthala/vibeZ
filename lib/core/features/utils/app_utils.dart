import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:music/core/features/shared/models/audio_track.dart';

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
