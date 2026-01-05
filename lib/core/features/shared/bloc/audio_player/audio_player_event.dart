// audio_player_event.dart
part of 'audio_player_bloc.dart';

abstract class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();

  @override
  List<Object?> get props => [];
}

class PlayTrack extends AudioPlayerEvent {
  final AudioTrack track;
  final List<AudioTrack> queue;

  const PlayTrack(this.track, this.queue);

  @override
  List<Object?> get props => [track, queue];
}

class PauseTrack extends AudioPlayerEvent {}

class ResumeTrack extends AudioPlayerEvent {}

class StopTrack extends AudioPlayerEvent {}

class SeekTrack extends AudioPlayerEvent {
  final Duration position;

  const SeekTrack(this.position);

  @override
  List<Object?> get props => [position];
}

class NextTrack extends AudioPlayerEvent {}

class PreviousTrack extends AudioPlayerEvent {}

/// Internal event for updating duration
class _UpdateDuration extends AudioPlayerEvent {
  final Duration duration;

  const _UpdateDuration(this.duration);

  @override
  List<Object?> get props => [duration];
}

class _UpdateIsPlaying extends AudioPlayerEvent {
  final bool isPlaying;

  const _UpdateIsPlaying(this.isPlaying);

  @override
  List<Object?> get props => [isPlaying];
}

/// Internal event for updating position
class _UpdatePosition extends AudioPlayerEvent {
  final Duration position;

  const _UpdatePosition(this.position);

  @override
  List<Object?> get props => [position];
}

// class _UpdatePlayerState extends AudioPlayerEvent {
//   final bool isPlaying;

//   const _UpdatePlayerState(this.isPlaying);

//   @override
//   List<Object?> get props => [isPlaying];
// }

class RestoreLastPlayback extends AudioPlayerEvent {
  final List<AudioTrack> allTracks;

  const RestoreLastPlayback(this.allTracks);

  @override
  List<Object?> get props => [allTracks];
}
