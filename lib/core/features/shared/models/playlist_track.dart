import 'package:equatable/equatable.dart';

class PlaylistTrack extends Equatable {
  final int? id;
  final int playlistId;
  final String trackId;
  final DateTime addedAt;
  final int position;

  const PlaylistTrack({
    this.id,
    required this.playlistId,
    required this.trackId,
    required this.addedAt,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playlistId': playlistId,
      'trackId': trackId,
      'addedAt': addedAt.toIso8601String(),
      'position': position,
    };
  }

  factory PlaylistTrack.fromMap(Map<String, dynamic> map) {
    return PlaylistTrack(
      id: map['id'] as int?,
      playlistId: map['playlistId'] as int,
      trackId: map['trackId'] as String,
      addedAt: DateTime.parse(map['addedAt'] as String),
      position: map['position'] as int,
    );
  }

  @override
  List<Object?> get props => [id, playlistId, trackId, addedAt, position];
}
