part of 'playlist_bloc.dart';

sealed class PlaylistState extends Equatable {
  const PlaylistState();

  @override
  List<Object?> get props => [];
}

final class PlaylistInitial extends PlaylistState {}

final class PlaylistLoading extends PlaylistState {}

final class PlaylistLoaded extends PlaylistState {
  final List<Playlist> playlists;
  final Playlist? selectedPlaylist;
  final bool detailsLoading;
  final String? detailsError;
  final bool actionLoading;
  final String? actionSuccess;
  final String? actionError;

  const PlaylistLoaded({
    this.playlists = const [],
    this.selectedPlaylist,
    this.detailsLoading = false,
    this.detailsError,
    this.actionLoading = false,
    this.actionSuccess,
    this.actionError,
  });

  @override
  List<Object?> get props => [
    playlists,
    selectedPlaylist,
    detailsLoading,
    detailsError,
    actionLoading,
    actionSuccess,
    actionError,
  ];
}

final class PlaylistError extends PlaylistState {
  final String message;

  const PlaylistError(this.message);

  @override
  List<Object?> get props => [message];
}
