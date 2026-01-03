part of 'audio_player_bloc.dart';

class AudioPlayerState extends Equatable {
  final AudioTrack? current;
  final List<AudioTrack> queue;
  final int currentIndex;
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  const AudioPlayerState({
    this.current,
    this.queue = const [],
    this.currentIndex = -1,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  AudioPlayerState copyWith({
    AudioTrack? current,
    List<AudioTrack>? queue,
    int? currentIndex,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool clearCurrent = false,
  }) {
    return AudioPlayerState(
      current: clearCurrent ? null : (current ?? this.current),
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [
    current,
    queue,
    currentIndex,
    isPlaying,
    position,
    duration,
  ];
}
