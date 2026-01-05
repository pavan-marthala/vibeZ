import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music/core/database/database_helper.dart';
import 'package:music/core/features/shared/models/playlist.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc() : super(PlaylistInitial()) {
    on<FetchPlayList>(_onFetch);
    on<CreatePlayList>(_onCreate);
    on<GetById>(_onGetById);
    on<Update>(_onUpdate);
    on<Delete>(_onDelete);
    on<AddTrack>(_onAddTrack);
    on<RemoveTrack>(_onRemoveTrack);
    on<GetTrackIds>(_onGetTrackIds);
    on<IsTrackInPlaylist>(_onIsTrackInPlaylist);
    on<IsTrackInFavorites>(_onIsTrackInFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> _onFetch(
    FetchPlayList event,
    Emitter<PlaylistState> emit,
  ) async {
    emit(PlaylistLoading());
    try {
      final playlists = await _databaseHelper.getAllPlaylists();
      emit(PlaylistLoaded(playlists: playlists));
    } catch (e) {
      emit(PlaylistError('Failed to fetch playlists'));
    }
  }

  Future<void> _onCreate(
    CreatePlayList event,
    Emitter<PlaylistState> emit,
  ) async {
    final currentState = state;
    final isPlistLoaded = currentState is PlaylistLoaded;
    final playlists = isPlistLoaded ? currentState.playlists : <Playlist>[];
    emit(
      PlaylistLoaded(
        playlists: playlists,
        selectedPlaylist: isPlistLoaded ? currentState.selectedPlaylist : null,
        actionLoading: true,
      ),
    );
    try {
      final playlist = await _databaseHelper.createPlaylist(
        event.name,
        description: event.description,
      );
      playlists.add(playlist);
      emit(
        PlaylistLoaded(
          playlists: playlists,
          actionLoading: false,
          actionSuccess: 'Playlist created successfully',
        ),
      );
    } catch (e) {
      emit(
        PlaylistLoaded(
          playlists: playlists,
          selectedPlaylist: isPlistLoaded
              ? currentState.selectedPlaylist
              : null,
          actionLoading: false,
          actionError: e.toString(),
        ),
      );
    }
  }

  Future<void> _onGetById(GetById event, Emitter<PlaylistState> emit) async {}

  Future<void> _onUpdate(Update event, Emitter<PlaylistState> emit) async {}

  Future<void> _onDelete(Delete event, Emitter<PlaylistState> emit) async {}

  Future<void> _onAddTrack(AddTrack event, Emitter<PlaylistState> emit) async {}

  Future<void> _onRemoveTrack(
    RemoveTrack event,
    Emitter<PlaylistState> emit,
  ) async {}

  Future<void> _onGetTrackIds(
    GetTrackIds event,
    Emitter<PlaylistState> emit,
  ) async {}

  Future<void> _onIsTrackInPlaylist(
    IsTrackInPlaylist event,
    Emitter<PlaylistState> emit,
  ) async {}

  Future<void> _onIsTrackInFavorites(
    IsTrackInFavorites event,
    Emitter<PlaylistState> emit,
  ) async {}

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<PlaylistState> emit,
  ) async {}
}
