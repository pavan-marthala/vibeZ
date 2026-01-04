import 'package:equatable/equatable.dart';
import 'package:music/core/features/shared/models/audio_track.dart';

class Album extends Equatable {
  final String id;
  final String name;
  final String artist;
  final List<AudioTrack> tracks;
  final String? albumArtPath;
  final int trackCount;
  final Duration totalDuration;

  const Album({
    required this.id,
    required this.name,
    required this.artist,
    required this.tracks,
    this.albumArtPath,
    required this.trackCount,
    required this.totalDuration,
  });

  factory Album.fromTracks(
    String albumName,
    String artist,
    List<AudioTrack> tracks,
  ) {
    final totalDuration = tracks.fold<Duration>(
      Duration.zero,
      (sum, track) => sum + track.duration,
    );

    final albumArtPath = tracks
        .firstWhere(
          (track) => track.albumArtPath != null,
          orElse: () => tracks.first,
        )
        .albumArtPath;

    return Album(
      id: '${albumName}_${artist}'.hashCode.toString(),
      name: albumName,
      artist: artist,
      tracks: tracks,
      albumArtPath: albumArtPath,
      trackCount: tracks.length,
      totalDuration: totalDuration,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    artist,
    tracks,
    albumArtPath,
    trackCount,
    totalDuration,
  ];
}
