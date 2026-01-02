part of 'music_library_bloc.dart';

sealed class MusicLibraryEvent extends Equatable {
  const MusicLibraryEvent();

  @override
  List<Object> get props => [];
}

class LoadAudioFiles extends MusicLibraryEvent {}

class RefreshAudioFiles extends MusicLibraryEvent {}

class SearchAudioFiles extends MusicLibraryEvent {
  final String query;
  const SearchAudioFiles(this.query);
  @override
  List<Object> get props => [query];
}
