import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/folder_selection/bloc/folder_selection_bloc.dart';
import 'package:music/core/features/request_permission/bloc/request_permission_bloc.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/bloc/music_library/music_library_bloc.dart';
import 'package:music/core/routes/router.dart';

void main() {
  final folderSelectiectionBloc = FolderSelectionBloc()..add(LoadFolders());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<RequestPermissionBloc>(
          create: (_) => RequestPermissionBloc()..add(CheckPermissionStatus()),
        ),

        BlocProvider<FolderSelectionBloc>(
          create: (_) => folderSelectiectionBloc,
        ),
        BlocProvider<MusicLibraryBloc>(
          create: (_) => MusicLibraryBloc()..add(LoadAudioFiles()),
        ),

        BlocProvider<AudioPlayerBloc>(create: (_) => AudioPlayerBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
    );
  }
}
