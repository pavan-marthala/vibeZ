import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:collection/collection.dart';
import 'dart:math';
import 'package:image/image.dart' as img;

/// Runs K-means clustering on image pixels.
Future<List<int>> extractDominantColorsKMeans(
  String imagePath, {
  int clusterCount = 8,
  int resize = 80,
}) async {
  final bytes = await File(imagePath).readAsBytes();
  final image = img.decodeImage(bytes);
  if (image == null) return [];

  final resized = img.copyResize(image, width: resize, height: resize);

  final pixels = <List<double>>[];
  for (int y = 0; y < resized.height; y++) {
    for (int x = 0; x < resized.width; x++) {
      final p = resized.getPixel(x, y);
      pixels.add([p.r.toDouble(), p.g.toDouble(), p.b.toDouble()]);
    }
  }

  final rand = Random();
  List<List<double>> centroids = List.generate(
    clusterCount,
    (_) => pixels[rand.nextInt(pixels.length)],
  );

  for (int iter = 0; iter < 10; iter++) {
    final clusters = List.generate(clusterCount, (_) => <List<double>>[]);

    for (final p in pixels) {
      int best = 0;
      double minDist = double.infinity;

      for (int i = 0; i < centroids.length; i++) {
        final dx = p[0] - centroids[i][0];
        final dy = p[1] - centroids[i][1];
        final dz = p[2] - centroids[i][2];
        final dist = dx * dx + dy * dy + dz * dz;

        if (dist < minDist) {
          minDist = dist;
          best = i;
        }
      }
      clusters[best].add(p);
    }

    for (int i = 0; i < centroids.length; i++) {
      if (clusters[i].isEmpty) continue;
      centroids[i] = [
        clusters[i].map((p) => p[0]).reduce((a, b) => a + b) /
            clusters[i].length,
        clusters[i].map((p) => p[1]).reduce((a, b) => a + b) /
            clusters[i].length,
        clusters[i].map((p) => p[2]).reduce((a, b) => a + b) /
            clusters[i].length,
      ];
    }
  }

  return centroids.map((c) {
    return (0xFF << 24) |
        (c[0].toInt() << 16) |
        (c[1].toInt() << 8) |
        c[2].toInt();
  }).toList();
}

bool isGoodAmbient(Color c) {
  final hsl = HSLColor.fromColor(c);
  return hsl.lightness > 0.18 && hsl.lightness < 0.85 && hsl.saturation > 0.25;
}

Color enhanceAmbient(Color c) {
  final hsl = HSLColor.fromColor(c);
  return hsl
      .withSaturation((hsl.saturation * 1.35).clamp(0.3, 1.0))
      .withLightness((hsl.lightness * 1.1).clamp(0.25, 0.75))
      .toColor();
}

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
