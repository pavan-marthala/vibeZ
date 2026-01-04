import 'package:equatable/equatable.dart';

class AudioTrack extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String album;
  final Duration duration;
  final String path;
  final String? albumArtPath;

  const AudioTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.path,
    this.albumArtPath,
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

  @override
  List<Object?> get props => [
    id,
    title,
    artist,
    album,
    duration,
    path,
    albumArtPath,
  ];
}
