// playlist_event.dart
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
  final int playlistId;

  const GetById(this.playlistId);

  @override
  List<Object?> get props => [playlistId];
}

class Update extends PlaylistEvent {
  final Playlist playlist;

  const Update(this.playlist);

  @override
  List<Object?> get props => [playlist];
}

class Delete extends PlaylistEvent {
  final int playlistId;

  const Delete(this.playlistId);

  @override
  List<Object?> get props => [playlistId];
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

  const GetTrackIds(this.playlistId);

  @override
  List<Object?> get props => [playlistId];
}

class IsTrackInPlaylist extends PlaylistEvent {
  final int playlistId;
  final String trackId;

  const IsTrackInPlaylist({required this.playlistId, required this.trackId});

  @override
  List<Object?> get props => [playlistId, trackId];
}

class IsTrackInFavorites extends PlaylistEvent {
  final String trackId;

  const IsTrackInFavorites(this.trackId);

  @override
  List<Object?> get props => [trackId];
}

class ToggleFavorite extends PlaylistEvent {
  final String trackId;

  const ToggleFavorite(this.trackId);

  @override
  List<Object?> get props => [trackId];
}
