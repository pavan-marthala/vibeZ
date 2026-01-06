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
      emit(PlaylistError('Failed to fetch playlists: ${e.toString()}'));
    }
  }

  Future<void> _onCreate(
    CreatePlayList event,
    Emitter<PlaylistState> emit,
  ) async {
    final currentState = state;
    final isPlaylistLoaded = currentState is PlaylistLoaded;
    final playlists = isPlaylistLoaded
        ? List<Playlist>.from(currentState.playlists)
        : <Playlist>[];

    emit(
      PlaylistLoaded(
        playlists: playlists,
        selectedPlaylist: isPlaylistLoaded
            ? currentState.selectedPlaylist
            : null,
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
          actionSuccess: 'Playlist "${event.name}" created successfully',
        ),
      );
    } catch (e) {
      emit(
        PlaylistLoaded(
          playlists: playlists,
          selectedPlaylist: isPlaylistLoaded
              ? currentState.selectedPlaylist
              : null,
          actionLoading: false,
          actionError: 'Failed to create playlist: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onGetById(GetById event, Emitter<PlaylistState> emit) async {
    final currentState = state;
    final isPlaylistLoaded = currentState is PlaylistLoaded;
    final playlists = isPlaylistLoaded ? currentState.playlists : <Playlist>[];

    emit(PlaylistLoaded(playlists: playlists, detailsLoading: true));

    try {
      final playlist = await _databaseHelper.getPlaylistById(event.playlistId);

      if (playlist == null) {
        emit(
          PlaylistLoaded(
            playlists: playlists,
            detailsLoading: false,
            detailsError: 'Playlist not found',
          ),
        );
        return;
      }

      emit(
        PlaylistLoaded(
          playlists: playlists,
          selectedPlaylist: playlist,
          detailsLoading: false,
        ),
      );
    } catch (e) {
      emit(
        PlaylistLoaded(
          playlists: playlists,
          detailsLoading: false,
          detailsError: 'Failed to load playlist: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUpdate(Update event, Emitter<PlaylistState> emit) async {
    final currentState = state;
    final isPlaylistLoaded = currentState is PlaylistLoaded;
    final playlists = isPlaylistLoaded
        ? List<Playlist>.from(currentState.playlists)
        : <Playlist>[];

    emit(
      PlaylistLoaded(
        playlists: playlists,
        selectedPlaylist: isPlaylistLoaded
            ? currentState.selectedPlaylist
            : null,
        actionLoading: true,
      ),
    );

    try {
      await _databaseHelper.updatePlaylist(event.playlist);

      // Update in list
      final index = playlists.indexWhere((p) => p.id == event.playlist.id);
      if (index != -1) {
        playlists[index] = event.playlist;
      }

      emit(
        PlaylistLoaded(
          playlists: playlists,
          selectedPlaylist: event.playlist,
          actionLoading: false,
          actionSuccess: 'Playlist updated successfully',
        ),
      );
    } catch (e) {
      emit(
        PlaylistLoaded(
          playlists: playlists,
          selectedPlaylist: isPlaylistLoaded
              ? currentState.selectedPlaylist
              : null,
          actionLoading: false,
          actionError: 'Failed to update playlist: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDelete(Delete event, Emitter<PlaylistState> emit) async {
    final currentState = state;
    final isPlaylistLoaded = currentState is PlaylistLoaded;
    final playlists = isPlaylistLoaded
        ? List<Playlist>.from(currentState.playlists)
        : <Playlist>[];

    emit(
      PlaylistLoaded(
        playlists: playlists,
        selectedPlaylist: isPlaylistLoaded
            ? currentState.selectedPlaylist
            : null,
        actionLoading: true,
      ),
    );

    try {
      await _databaseHelper.deletePlaylist(event.playlistId);

      // Remove from list
      playlists.removeWhere((p) => p.id == event.playlistId);

      emit(
        PlaylistLoaded(
          playlists: playlists,
          actionLoading: false,
          actionSuccess: 'Playlist deleted successfully',
        ),
      );
    } catch (e) {
      emit(
        PlaylistLoaded(
          playlists: playlists,
          selectedPlaylist: isPlaylistLoaded
              ? currentState.selectedPlaylist
              : null,
          actionLoading: false,
          actionError: e.toString().contains('Cannot delete default')
              ? 'Cannot delete Favorites playlist'
              : 'Failed to delete playlist: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onAddTrack(AddTrack event, Emitter<PlaylistState> emit) async {
    final currentState = state;
    final isPlaylistLoaded = currentState is PlaylistLoaded;
    final playlists = isPlaylistLoaded
        ? List<Playlist>.from(currentState.playlists)
        : <Playlist>[];

    emit(
      PlaylistLoaded(
        playlists: playlists,
        selectedPlaylist: isPlaylistLoaded
            ? currentState.selectedPlaylist
            : null,
        actionLoading: true,
      ),
    );

    try {
      await _databaseHelper.addTrackToPlaylist(event.playlistId, event.trackId);

      // Refresh playlist to get updated track count
      final updatedPlaylist = await _databaseHelper.getPlaylistById(
        event.playlistId,
      );

      if (updatedPlaylist != null) {
        final index = playlists.indexWhere((p) => p.id == event.playlistId);
        if (index != -1) {
          playlists[index] = updatedPlaylist;
        }
      }

      emit(
        PlaylistLoaded(
          playlists: playlists,
          selectedPlaylist: updatedPlaylist,
          actionLoading: false,
          actionSuccess: 'Track added to playlist',
        ),
      );
    } catch (e) {
      emit(
        PlaylistLoaded(
          playlists: playlists,
          selectedPlaylist: isPlaylistLoaded
              ? currentState.selectedPlaylist
              : null,
          actionLoading: false,
          actionError: e.toString().contains('already in playlist')
              ? 'Track already in playlist'
              : 'Failed to add track: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRemoveTrack(
    RemoveTrack event,
    Emitter<PlaylistState> emit,
  ) async {
    final currentState = state;
    final isPlaylistLoaded = currentState is PlaylistLoaded;
    final playlists = isPlaylistLoaded
        ? List<Playlist>.from(currentState.playlists)
        : <Playlist>[];

    emit(
      PlaylistLoaded(
        playlists: playlists,
        selectedPlaylist: isPlaylistLoaded
            ? currentState.selectedPlaylist
            : null,
        actionLoading: true,
      ),
    );

    try {
      await _databaseHelper.removeTrackFromPlaylist(
        event.playlistId,
        event.trackId,
      );

      // Refresh playlist to get updated track count
      final updatedPlaylist = await _databaseHelper.getPlaylistById(
        event.playlistId,
      );

      if (updatedPlaylist != null) {
        final index = playlists.indexWhere((p) => p.id == event.playlistId);
        if (index != -1) {
          playlists[index] = updatedPlaylist;
        }
      }

      emit(
        PlaylistLoaded(
          playlists: playlists,
          selectedPlaylist: updatedPlaylist,
          actionLoading: false,
          actionSuccess: 'Track removed from playlist',
        ),
      );
    } catch (e) {
      emit(
        PlaylistLoaded(
          playlists: playlists,
          selectedPlaylist: isPlaylistLoaded
              ? currentState.selectedPlaylist
              : null,
          actionLoading: false,
          actionError: 'Failed to remove track: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onGetTrackIds(
    GetTrackIds event,
    Emitter<PlaylistState> emit,
  ) async {
    // This is typically used to get track IDs for playing a playlist
    // You might want to handle this differently based on your needs
    try {
      final trackIds = await _databaseHelper.getPlaylistTrackIds(
        event.playlistId,
      );
      // You might emit a different state or handle this differently
      print('Playlist tracks: $trackIds');
    } catch (e) {
      print('Error getting track IDs: $e');
    }
  }

  Future<void> _onIsTrackInPlaylist(
    IsTrackInPlaylist event,
    Emitter<PlaylistState> emit,
  ) async {
    // This is typically used for UI checks (showing heart icon, etc.)
    // Doesn't change the main state
    try {
      final isInPlaylist = await _databaseHelper.isTrackInPlaylist(
        event.playlistId,
        event.trackId,
      );
      print('Track in playlist: $isInPlaylist');
    } catch (e) {
      print('Error checking track: $e');
    }
  }

  Future<void> _onIsTrackInFavorites(
    IsTrackInFavorites event,
    Emitter<PlaylistState> emit,
  ) async {
    // Similar to above, used for UI checks
    try {
      final isInFavorites = await _databaseHelper.isTrackInFavorites(
        event.trackId,
      );
      print('Track in favorites: $isInFavorites');
    } catch (e) {
      print('Error checking favorites: $e');
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<PlaylistState> emit,
  ) async {
    final currentState = state;
    final isPlaylistLoaded = currentState is PlaylistLoaded;
    final playlists = isPlaylistLoaded
        ? List<Playlist>.from(currentState.playlists)
        : <Playlist>[];

    emit(
      PlaylistLoaded(
        playlists: playlists,
        selectedPlaylist: isPlaylistLoaded
            ? currentState.selectedPlaylist
            : null,
        actionLoading: true,
      ),
    );

    try {
      final wasInFavorites = await _databaseHelper.isTrackInFavorites(
        event.trackId,
      );
      await _databaseHelper.toggleFavorite(event.trackId);

      // Refresh favorites playlist
      final favPlaylist = await _databaseHelper.getFavoritesPlaylist();
      if (favPlaylist != null) {
        final index = playlists.indexWhere((p) => p.id == favPlaylist.id);
        if (index != -1) {
          playlists[index] = favPlaylist;
        }
      }

      emit(
        PlaylistLoaded(
          playlists: playlists,
          selectedPlaylist: isPlaylistLoaded
              ? currentState.selectedPlaylist
              : null,
          actionLoading: false,
          actionSuccess: wasInFavorites
              ? 'Removed from favorites'
              : 'Added to favorites',
        ),
      );
    } catch (e) {
      emit(
        PlaylistLoaded(
          playlists: playlists,
          selectedPlaylist: isPlaylistLoaded
              ? currentState.selectedPlaylist
              : null,
          actionLoading: false,
          actionError: 'Failed to toggle favorite: ${e.toString()}',
        ),
      );
    }
  }
}
