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
  final SortOption sortOption;
  final SortOrder sortOrder;

  const MusicLibraryLoaded(
    this.tracks, [
    this.albums = const [],
    this.sortOption = SortOption.title,
    this.sortOrder = SortOrder.ascending,
  ]);

  @override
  List<Object> get props => [tracks, albums, sortOption, sortOrder];
}

enum SortOption { title, artist, album, year, dateAdded, dateModified }

enum SortOrder { ascending, descending }

final class MusicLibraryError extends MusicLibraryState {
  final String message;

  const MusicLibraryError(this.message);

  @override
  List<Object> get props => [message];
}
