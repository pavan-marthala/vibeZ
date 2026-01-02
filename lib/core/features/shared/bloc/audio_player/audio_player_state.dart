part of 'audio_player_bloc.dart';

class AudioPlayerState extends Equatable {
  final AudioTrack? current;
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  const AudioPlayerState({
    this.current,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  AudioPlayerState copyWith({
    AudioTrack? current,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
  }) {
    return AudioPlayerState(
      current: current ?? this.current,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [current, isPlaying, position, duration];
}
