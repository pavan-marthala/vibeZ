part of 'audio_player_bloc.dart';

sealed class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();

  @override
  List<Object> get props => [];
}

class PlayTrack extends AudioPlayerEvent {
  final AudioTrack track;
  const PlayTrack(this.track);
  @override
  List<Object> get props => [track];
}

class PauseTrack extends AudioPlayerEvent {}

class ResumeTrack extends AudioPlayerEvent {}

class SeekTrack extends AudioPlayerEvent {
  final Duration position;
  const SeekTrack(this.position);
  @override
  List<Object> get props => [position];
}
