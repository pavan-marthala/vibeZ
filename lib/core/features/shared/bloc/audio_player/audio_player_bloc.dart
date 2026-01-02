import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/core/features/shared/models/audio_track.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AudioPlayer _player = AudioPlayer();
  AudioPlayerBloc() : super(AudioPlayerState()) {
    on<PlayTrack>(_onPlayTrack);
    on<PauseTrack>(_onPauseTrack);
    on<ResumeTrack>(_onResumeTrack);
    on<SeekTrack>(_onSeekTrack);

    _player.positionStream.listen((pos) {
      add(SeekTrack(pos));
    });
  }
  Future<void> _onPlayTrack(
    PlayTrack event,
    Emitter<AudioPlayerState> emit,
  ) async {
    await _player.setFilePath(event.track.path);
    _player.play();

    emit(
      state.copyWith(
        current: event.track,
        isPlaying: true,
        duration: _player.duration ?? Duration.zero,
      ),
    );
  }

  Future<void> _onPauseTrack(
    PauseTrack event,
    Emitter<AudioPlayerState> emit,
  ) async {
    await _player.pause();
    emit(state.copyWith(isPlaying: false));
  }

  Future<void> _onResumeTrack(
    ResumeTrack event,
    Emitter<AudioPlayerState> emit,
  ) async {
    await _player.play();
    emit(state.copyWith(isPlaying: true));
  }

  Future<void> _onSeekTrack(
    SeekTrack event,
    Emitter<AudioPlayerState> emit,
  ) async {
    await _player.seek(event.position);
    emit(state.copyWith(position: event.position));
  }
}
