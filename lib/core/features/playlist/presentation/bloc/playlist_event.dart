part of 'playlist_bloc.dart';

sealed class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object?> get props => [];
}

class FetchPlayList extends PlaylistEvent {}

class CreatePlayList extends PlaylistEvent {
  final String name;
  final String? description;

  const CreatePlayList({required this.name, this.description});

  @override
  List<Object?> get props => [name, description];
}

class GetById extends PlaylistEvent {
  final int id;

  const GetById({required this.id});

  @override
  List<Object?> get props => [id];
}

class Update extends PlaylistEvent {
  final Playlist playlist;

  const Update({required this.playlist});

  @override
  List<Object?> get props => [playlist];
}

class Delete extends PlaylistEvent {
  final int id;

  const Delete({required this.id});

  @override
  List<Object?> get props => [id];
}

class AddTrack extends PlaylistEvent {
  final int playlistId;
  final String trackId;

  const AddTrack({required this.playlistId, required this.trackId});

  @override
  List<Object?> get props => [playlistId, trackId];
}

class RemoveTrack extends PlaylistEvent {
  final int playlistId;
  final String trackId;

  const RemoveTrack({required this.playlistId, required this.trackId});

  @override
  List<Object?> get props => [playlistId, trackId];
}

class GetTrackIds extends PlaylistEvent {
  final int playlistId;

  const GetTrackIds({required this.playlistId});

  @override
  List<Object?> get props => [playlistId];
}

class IsTrackInPlaylist extends PlaylistEvent {
  final int playlistId;
  final String trackId;
  final bool Function(bool) callback;

  const IsTrackInPlaylist({
    required this.playlistId,
    required this.trackId,
    required this.callback,
  });

  @override
  List<Object?> get props => [playlistId, trackId];
}

class IsTrackInFavorites extends PlaylistEvent {
  final String trackId;
  final bool Function(bool) callback;

  const IsTrackInFavorites({required this.trackId, required this.callback});
}

class ToggleFavorite extends PlaylistEvent {
  final String trackId;

  const ToggleFavorite({required this.trackId});
}
