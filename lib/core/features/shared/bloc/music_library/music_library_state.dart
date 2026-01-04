part of 'music_library_bloc.dart';

sealed class MusicLibraryState extends Equatable {
  const MusicLibraryState();

  @override
  List<Object> get props => [];
}

final class MusicLibraryInitial extends MusicLibraryState {}

final class MusicLibraryLoading extends MusicLibraryState {}

final class MusicLibraryLoaded extends MusicLibraryState {
  final List<AudioTrack> tracks;
  final List<Album> albums;

  const MusicLibraryLoaded(this.tracks, [this.albums = const []]);

  @override
  List<Object> get props => [tracks, albums];
}

final class MusicLibraryError extends MusicLibraryState {
  final String message;

  const MusicLibraryError(this.message);

  @override
  List<Object> get props => [message];
}
