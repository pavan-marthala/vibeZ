import 'package:equatable/equatable.dart';
import 'package:music/core/features/shared/models/play_history.dart';

class ListeningStats extends Equatable {
  final int totalPlays;
  final int totalListeningTime;
  final int uniqueTracks;
  final int uniqueArtists;
  final String mostPlayedTrack;
  final String topArtist;
  final List<TrackStats> topTracks;
  final List<ArtistStats> topArtists;
  final List<PlayHistory> recentHistory;

  const ListeningStats({
    required this.totalPlays,
    required this.totalListeningTime,
    required this.uniqueTracks,
    required this.uniqueArtists,
    required this.mostPlayedTrack,
    required this.topArtist,
    required this.topTracks,
    required this.topArtists,
    required this.recentHistory,
  });

  @override
  List<Object?> get props => [
    totalPlays,
    totalListeningTime,
    uniqueTracks,
    uniqueArtists,
    mostPlayedTrack,
    topArtist,
    topTracks,
    topArtists,
    recentHistory,
  ];
}

class TrackStats extends Equatable {
  final String trackId;
  final String title;
  final String artist;
  final int playCount;
  final int totalPlayTime;
  final String? albumArtPath;

  const TrackStats({
    required this.trackId,
    required this.title,
    required this.artist,
    required this.playCount,
    required this.totalPlayTime,
    this.albumArtPath,
  });

  @override
  List<Object?> get props => [
    trackId,
    title,
    artist,
    playCount,
    totalPlayTime,
    albumArtPath,
  ];
}

class ArtistStats extends Equatable {
  final String artist;
  final int playCount;
  final int totalPlayTime;
  final int trackCount;

  const ArtistStats({
    required this.artist,
    required this.playCount,
    required this.totalPlayTime,
    required this.trackCount,
  });

  @override
  List<Object?> get props => [artist, playCount, totalPlayTime, trackCount];
}
