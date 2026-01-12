// lib/core/features/shared/bloc/music_library/music_library_bloc.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music/core/database/database_helper.dart';
import 'package:music/core/features/shared/models/album.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:music/core/features/utils/album_art_cache.dart';
import 'package:path/path.dart' as path;

part 'music_library_event.dart';
part 'music_library_state.dart';

class MusicLibraryBloc extends Bloc<MusicLibraryEvent, MusicLibraryState> {
  MusicLibraryBloc() : super(MusicLibraryInitial()) {
    on<LoadAudioFiles>(_onLoadAudioFiles);
    on<RefreshAudioFiles>(_onRefreshAudioFiles);
    on<SearchAudioFiles>(_onSearchAudioFiles);
    on<SortTracks>(_onSortTracks);
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> _onLoadAudioFiles(
    LoadAudioFiles event,
    Emitter<MusicLibraryState> emit,
  ) async {
    emit(MusicLibraryLoading());
    try {
      final uniqueTracks = <String, AudioTrack>{};
      final storageDirs = await _getAllStorageDirectories();

      for (final dir in storageDirs) {
        final audioFiles = await _scanDirectoryForAudioFiles(dir);
        for (final track in audioFiles) {
          uniqueTracks[track.path] = track;
        }
      }

      final tracks = uniqueTracks.values.toList();
      // Group tracks into albums
      final albums = _groupTracksIntoAlbums(tracks);

      emit(MusicLibraryLoaded(tracks, albums));
    } catch (e) {
      emit(MusicLibraryError('Failed to load audio files'));
    }
  }

  Future<void> _onRefreshAudioFiles(
    RefreshAudioFiles event,
    Emitter<MusicLibraryState> emit,
  ) async {
    try {
      final tracks = <AudioTrack>[];
      final albums = _groupTracksIntoAlbums(tracks);
      emit(MusicLibraryLoaded(tracks, albums));
    } catch (e) {
      emit(MusicLibraryError('Failed to refresh audio files'));
    }
  }

  Future<void> _onSearchAudioFiles(
    SearchAudioFiles event,
    Emitter<MusicLibraryState> emit,
  ) async {
    if (state is! MusicLibraryLoaded) return;

    try {
      final currentState = state as MusicLibraryLoaded;
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        emit(MusicLibraryLoaded(currentState.tracks, currentState.albums));
        return;
      }

      final filteredTracks = currentState.tracks
          .where(
            (track) =>
                track.title.toLowerCase().contains(query) ||
                track.artist.toLowerCase().contains(query) ||
                track.album.toLowerCase().contains(query) ||
                (track.year?.toString().contains(query) ?? false),
          )
          .toList();

      final filteredAlbums = _groupTracksIntoAlbums(filteredTracks);

      emit(MusicLibraryLoaded(filteredTracks, filteredAlbums));
    } catch (e) {
      emit(MusicLibraryError('Failed to search audio files'));
    }
  }

  Future<void> _onSortTracks(
    SortTracks event,
    Emitter<MusicLibraryState> emit,
  ) async {
    if (state is! MusicLibraryLoaded) return;
    final currentState = state as MusicLibraryLoaded;

    final sortedTracks = List<AudioTrack>.from(currentState.tracks);

    sortedTracks.sort((a, b) {
      int comparison = 0;
      switch (event.option) {
        case SortOption.title:
          comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
          break;
        case SortOption.artist:
          comparison = a.artist.toLowerCase().compareTo(b.artist.toLowerCase());
          break;
        case SortOption.album:
          comparison = a.album.toLowerCase().compareTo(b.album.toLowerCase());
          break;
        case SortOption.year:
          comparison = (a.year ?? 0).compareTo(b.year ?? 0);
          break;
        case SortOption.dateAdded:
          comparison = (a.dateAdded ?? DateTime(0)).compareTo(
            b.dateAdded ?? DateTime(0),
          );
          break;
        case SortOption.dateModified:
          comparison = (a.dateModified ?? DateTime(0)).compareTo(
            b.dateModified ?? DateTime(0),
          );
          break;
      }
      return event.order == SortOrder.ascending ? comparison : -comparison;
    });

    // Re-group albums based on sorted tracks (optional, but albums list usually stays strictly alphabetical or we can sort albums too?
    // The prompt asked for "in tracks page... sorting". Usually this affects the *track list* display.
    // The `MusicLibraryBloc` emits `tracks` and `albums`.
    // If we sort tracks, the `tracks` list is updated.

    emit(
      MusicLibraryLoaded(
        sortedTracks,
        currentState.albums,
        event.option,
        event.order,
      ),
    );
  }

  List<Album> _groupTracksIntoAlbums(List<AudioTrack> tracks) {
    final Map<String, List<AudioTrack>> albumMap = {};

    for (final track in tracks) {
      // Use album name + primary artist as key to group tracks
      final key = '${track.album}_${track.primaryArtist}';

      if (!albumMap.containsKey(key)) {
        albumMap[key] = [];
      }
      albumMap[key]!.add(track);
    }

    return albumMap.entries.map((entry) {
        final tracks = entry.value;
        // Sort tracks by title
        tracks.sort((a, b) => a.title.compareTo(b.title));

        return Album.fromTracks(
          tracks.first.album,
          tracks.first.primaryArtist,
          tracks,
        );
      }).toList()
      ..sort((a, b) => a.name.compareTo(b.name)); // Sort albums alphabetically
  }

  Future<List<String>> _getAllStorageDirectories() async {
    try {
      final folders = await _databaseHelper.getAllFolders();
      if (folders.isNotEmpty) {
        final directories = folders.map((folder) => folder.path).toList();
        directories.add("/storage/emulated/0/Download");
        return directories;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AudioTrack>> _scanDirectoryForAudioFiles(String dirPath) async {
    try {
      final directory = Directory(dirPath);
      final audioFiles = <AudioTrack>[];
      await for (final entity in directory.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File && _isAudioFile(entity.path)) {
          final track = await _createTrackFromFile(entity);
          if (track != null) {
            audioFiles.add(track);
          }
        }
      }
      return audioFiles;
    } catch (e) {
      rethrow;
    }
  }

  bool _isAudioFile(String filePath) {
    final audioExtensions = [
      '.mp3',
      '.wav',
      '.aac',
      '.flac',
      '.m4a',
      '.ogg',
      '.wma',
      '.opus',
    ];
    final extension = path.extension(filePath).toLowerCase();
    return audioExtensions.contains(extension);
  }

  Future<AudioTrack?> _createTrackFromFile(File file) async {
    try {
      final metadata = readMetadata(file, getImage: true);
      Uint8List? rawArt;
      if (metadata.pictures.isNotEmpty) {
        rawArt = metadata.pictures.first.bytes;
      }

      final artPath = await AlbumArtCache.save(
        rawArt,
        file.path.hashCode.toString(),
      );

      final title = metadata.title?.trim().isNotEmpty == true
          ? metadata.title!
          : path.basenameWithoutExtension(file.path);

      final artist = metadata.artist?.trim().isNotEmpty == true
          ? metadata.artist!
          : 'Unknown Artist';

      final album = metadata.album?.trim().isNotEmpty == true
          ? metadata.album!
          : 'Unknown Album';

      final duration = metadata.duration ?? Duration.zero;
      final year = metadata.year?.year;

      DateTime dateModified;
      try {
        dateModified = await file.lastModified();
      } catch (_) {
        dateModified = DateTime.now();
      }

      return AudioTrack(
        id: file.path.hashCode.toString(),
        title: title,
        artist: artist,
        album: album,
        duration: duration,
        path: file.path,
        albumArtPath: artPath,
        dateAdded: dateModified, // Approximating dateAdded as dateModified
        dateModified: dateModified,
        year: year,
      );
    } catch (e) {
      return null;
    }
  }
}
