import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/core/database/database_helper.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:path/path.dart' as path;
part 'music_library_event.dart';
part 'music_library_state.dart';

class MusicLibraryBloc extends Bloc<MusicLibraryEvent, MusicLibraryState> {
  MusicLibraryBloc() : super(MusicLibraryInitial()) {
    on<LoadAudioFiles>(_onLoadAudioFiles);
    on<RefreshAudioFiles>(_onRefreshAudioFiles);
    on<SearchAudioFiles>(_onSearchAudioFiles);
  }
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> _onLoadAudioFiles(
    LoadAudioFiles event,
    Emitter<MusicLibraryState> emit,
  ) async {
    emit(MusicLibraryLoading());
    try {
      final tracks = <AudioTrack>[];
      final storageDirs = await _getAllStorageDirectories();
      for (final dir in storageDirs) {
        final audioFiles = await _scanDirectoryForAudioFiles(dir);
        tracks.addAll(audioFiles);
      }
      emit(MusicLibraryLoaded(tracks));
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
      emit(MusicLibraryLoaded(tracks));
    } catch (e) {
      emit(MusicLibraryError('Failed to refresh audio files'));
    }
  }

  Future<void> _onSearchAudioFiles(
    SearchAudioFiles event,
    Emitter<MusicLibraryState> emit,
  ) async {
    try {
      final allTracks = <AudioTrack>[];
      final filteredTracks = allTracks
          .where(
            (track) =>
                track.title.toLowerCase().contains(event.query.toLowerCase()),
          )
          .toList();
      emit(MusicLibraryLoaded(filteredTracks));
    } catch (e) {
      emit(MusicLibraryError('Failed to search audio files'));
    }
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
      // final fileStat = await file.stat();
      final fileName = path.basenameWithoutExtension(file.path);
      String title = fileName;
      final id = file.path.hashCode.toString();
      String artist = 'Unknown Artist';
      String album = 'Unknown Album';
      Duration duration = Duration.zero;
      try {
        final tempPlayer = AudioPlayer();
        await tempPlayer.setFilePath(file.path);
        duration = tempPlayer.duration ?? Duration.zero;
        await tempPlayer.dispose();
      } catch (e) {
        if (fileName.contains('-')) {
          final parts = fileName.split('-');
          if (parts.length >= 2) {
            artist = parts[0].trim();
            title = parts.sublist(1).join('-').trim();
          }
        }
      }
      final track = AudioTrack(
        id: id,
        title: title,
        artist: artist,
        album: album,
        duration: duration,
        path: file.path,
      );
      return track;
    } catch (e) {
      return null;
    }
  }
}
