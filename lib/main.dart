import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/folder_selection/bloc/folder_selection_bloc.dart';
import 'package:music/core/features/request_permission/bloc/request_permission_bloc.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/bloc/music_library/music_library_bloc.dart';
import 'package:music/core/routes/router.dart';
import 'package:music/core/theme/app_theme.dart';

import 'core/service/vibez_audio_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final handler = await AudioService.init(
    builder: () => VibezAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'app.vibez.music',
      androidNotificationChannelName: 'Vibez Playback',
      androidNotificationOngoing: true,
    ),
  );
  final folderSelectionBloc = FolderSelectionBloc()..add(LoadFolders());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<RequestPermissionBloc>(
          create: (_) => RequestPermissionBloc()..add(CheckPermissionStatus()),
        ),

        BlocProvider<FolderSelectionBloc>(create: (_) => folderSelectionBloc),
        BlocProvider<MusicLibraryBloc>(
          create: (_) => MusicLibraryBloc()..add(LoadAudioFiles()),
        ),

        BlocProvider<AudioPlayerBloc>(create: (_) => AudioPlayerBloc(handler)),
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
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
    );
  }
}
