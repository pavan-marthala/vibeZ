import 'package:equatable/equatable.dart';

class PlayHistory extends Equatable {
  final int? id;
  final String trackId;
  final String trackTitle;
  final String artist;
  final String album;
  final DateTime playedAt;
  final int playDuration;
  final bool completed;
  final String? albumArtPath;

  const PlayHistory({
    this.id,
    required this.trackId,
    required this.trackTitle,
    required this.artist,
    required this.album,
    required this.playedAt,
    required this.playDuration,
    this.completed = false,
    this.albumArtPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trackId': trackId,
      'trackTitle': trackTitle,
      'artist': artist,
      'album': album,
      'playedAt': playedAt.toIso8601String(),
      'playDuration': playDuration,
      'completed': completed ? 1 : 0,
      'albumArtPath': albumArtPath,
    };
  }

  factory PlayHistory.fromMap(Map<String, dynamic> map) {
    return PlayHistory(
      id: map['id'] as int?,
      trackId: map['trackId'] as String,
      trackTitle: map['trackTitle'] as String,
      artist: map['artist'] as String,
      album: map['album'] as String,
      playedAt: DateTime.parse(map['playedAt'] as String),
      playDuration: map['playDuration'] as int,
      completed: (map['completed'] as int) == 1,
      albumArtPath: map['albumArtPath'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    trackId,
    trackTitle,
    artist,
    album,
    playedAt,
    playDuration,
    completed,
    albumArtPath,
  ];
}

class ArtistData {
  final String artist;
  final Set<String> trackIds;
  int playCount;
  int totalPlayTime;

  ArtistData({
    required this.artist,
    required this.trackIds,
    required this.playCount,
    required this.totalPlayTime,
  });
}
