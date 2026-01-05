import 'package:equatable/equatable.dart';

class PlaybackState extends Equatable {
  final String trackId;
  final String trackPath;
  final int positionMs;
  final DateTime savedAt;

  const PlaybackState({
    required this.trackId,
    required this.trackPath,
    required this.positionMs,
    required this.savedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'trackId': trackId,
      'trackPath': trackPath,
      'positionMs': positionMs,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory PlaybackState.fromMap(Map<String, dynamic> map) {
    return PlaybackState(
      trackId: map['trackId'] as String,
      trackPath: map['trackPath'] as String,
      positionMs: map['positionMs'] as int,
      savedAt: DateTime.parse(map['savedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [trackId, trackPath, positionMs, savedAt];
}
