import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/core/database/database_helper.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:music/core/features/shared/models/play_history.dart';
import 'package:music/core/service/vibez_audio_handler.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final VibezAudioHandler handler;
  late final StreamSubscription _playerStateSub;
  late final StreamSubscription _positionSub;
  late final StreamSubscription _durationSub;
  DateTime? _trackStartTime;
  int _totalPlayDuration = 0;

  AudioPlayerBloc(this.handler) : super(const AudioPlayerState()) {
    on<PlayTrack>(_onPlayTrack);
    on<PauseTrack>((_, _) => handler.pause());
    on<ResumeTrack>((_, _) => handler.play());
    on<SeekTrack>((e, _) => handler.seek(e.position));
    on<StopTrack>(_onStopTrack);
    on<NextTrack>(_onNextTrack);
    on<PreviousTrack>(_onPreviousTrack);

    /// Listen to player state
    _playerStateSub = handler.player.playerStateStream.listen((playerState) {
      final playing =
          playerState.playing &&
          playerState.processingState == ProcessingState.ready;

      add(_UpdateIsPlaying(playing));

      if (playerState.processingState == ProcessingState.completed) {
        add(NextTrack());
      }
    });

    _positionSub = handler.player.positionStream.listen((pos) {
      add(_UpdatePosition(pos));
    });

    _durationSub = handler.player.durationStream.listen((dur) {
      if (dur != null) add(_UpdateDuration(dur));
    });

    on<_UpdateIsPlaying>(
      (e, emit) => emit(state.copyWith(isPlaying: e.isPlaying)),
    );

    on<_UpdatePosition>(
      (e, emit) => emit(state.copyWith(position: e.position)),
    );

    on<_UpdateDuration>(
      (e, emit) => emit(state.copyWith(duration: e.duration)),
    );
  }

  Future<void> _onPlayTrack(
    PlayTrack event,
    Emitter<AudioPlayerState> emit,
  ) async {
    try {
      final index = event.queue.indexWhere(
        (track) => track.id == event.track.id,
      );
      if (state.current != null && _trackStartTime != null) {
        await _savePlayHistory(state.current!);
      }

      _trackStartTime = DateTime.now();
      _totalPlayDuration = 0;
      emit(
        state.copyWith(
          current: event.track,
          queue: event.queue,
          currentIndex: index,
          position: Duration.zero,
        ),
      );

      /// Play the track
      await handler.playTrack(event.track);
    } catch (e) {
      log('Error playing track: $e');
      emit(state.copyWith(isPlaying: false, clearCurrent: true));
    }
  }

  Future<void> _onNextTrack(
    NextTrack event,
    Emitter<AudioPlayerState> emit,
  ) async {
    if (state.queue.isEmpty || state.currentIndex < 0) return;

    final nextIndex = state.currentIndex + 1;

    if (nextIndex >= state.queue.length) return;

    final nextTrack = state.queue[nextIndex];
    if (state.current != null && _trackStartTime != null) {
      await _savePlayHistory(state.current!);
    }

    _trackStartTime = DateTime.now();
    _totalPlayDuration = 0;
    emit(
      state.copyWith(
        current: nextTrack,
        currentIndex: nextIndex,
        position: Duration.zero,
      ),
    );
    await handler.playTrack(nextTrack);
  }

  Future<void> _onPreviousTrack(
    PreviousTrack event,
    Emitter<AudioPlayerState> emit,
  ) async {
    final prevIndex = state.currentIndex - 1;

    if (prevIndex < 0) return;

    final prevTrack = state.queue[prevIndex];
    if (state.current != null && _trackStartTime != null) {
      await _savePlayHistory(state.current!);
    }

    _trackStartTime = DateTime.now();
    _totalPlayDuration = 0;
    emit(
      state.copyWith(
        current: prevTrack,
        currentIndex: prevIndex,
        position: Duration.zero,
      ),
    );
    await handler.playTrack(prevTrack);
  }

  Future<void> _onStopTrack(
    StopTrack event,
    Emitter<AudioPlayerState> emit,
  ) async {
    log('Stopping track');
    if (state.current != null && _trackStartTime != null) {
      await _savePlayHistory(state.current!);
    }
    _trackStartTime = null;
    _totalPlayDuration = 0;
    await handler.stop();
    emit(const AudioPlayerState());
  }

  @override
  Future<void> close() async {
    if (state.current != null && _trackStartTime != null) {
      await _savePlayHistory(state.current!);
    }
    _playerStateSub.cancel();
    _positionSub.cancel();
    _durationSub.cancel();
    return super.close();
  }

  Future<void> _savePlayHistory(AudioTrack track) async {
    if (_trackStartTime == null) return;

    final playDuration = DateTime.now().difference(_trackStartTime!).inSeconds;
    final completed =
        track.duration.inSeconds > 0 &&
        playDuration >= (track.duration.inSeconds * 0.8);

    final history = PlayHistory(
      trackId: track.id,
      trackTitle: track.title,
      artist: track.artist,
      album: track.album,
      playedAt: _trackStartTime!,
      playDuration: playDuration,
      completed: completed,
      albumArtPath: track.albumArtPath,
    );

    try {
      await DatabaseHelper.instance.insertPlayHistory(history);
    } catch (e) {
      print('Error saving play history: $e');
    }
  }
}
