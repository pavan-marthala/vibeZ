import 'dart:ui';

import 'package:equatable/equatable.dart';

class AudioTrack extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String album;
  final Duration duration;
  final String path;
  final String? albumArtPath;
  final DateTime? dateAdded;
  final DateTime? dateModified;
  final int? year;
  final List<Color>? ambientColors;

  const AudioTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.path,
    this.albumArtPath,
    this.dateAdded,
    this.dateModified,
    this.year,
    this.ambientColors,
  });

  List<String> get artists {
    return artist
        .split(RegExp(r'[,;&/]'))
        .map((a) => a.trim())
        .where((a) => a.isNotEmpty)
        .toList();
  }

  String get primaryArtist {
    final artistList = artists;
    return artistList.isNotEmpty ? artistList.first : artist;
  }

  AudioTrack copyWith({List<Color>? ambientColors}) {
    return AudioTrack(
      id: id,
      title: title,
      artist: artist,
      album: album,
      duration: duration,
      path: path,
      albumArtPath: albumArtPath,
      dateAdded: dateAdded,
      dateModified: dateModified,
      year: year,
      ambientColors: ambientColors,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    artist,
    album,
    duration,
    path,
    albumArtPath,
    dateAdded,
    dateModified,
    year,
    ambientColors,
  ];
}
