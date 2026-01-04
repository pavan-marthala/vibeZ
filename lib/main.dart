import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/features/folder_selection/bloc/folder_selection_bloc.dart';
import 'package:music/core/features/request_permission/bloc/request_permission_bloc.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/bloc/music_library/music_library_bloc.dart';
import 'package:music/core/features/shared/bloc/stats_bloc_bloc/stats_bloc.dart';
import 'package:music/core/routes/app_routes.dart';
import 'package:music/core/routes/router.dart';
import 'package:music/core/theme/app_theme.dart';

import 'core/service/vibez_audio_handler.dart';

void main() async {
  final permissionBloc = RequestPermissionBloc()..add(CheckPermissionStatus());
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
        BlocProvider<RequestPermissionBloc>(create: (_) => permissionBloc),
        BlocProvider<StatsBloc>(create: (_) => StatsBloc()..add(LoadStats())),
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: true,
      initialLocation: AppRoutes.splash,
      refreshListenable: GoRouterRefreshStream(
        context.read<RequestPermissionBloc>().stream,
      ),
      redirect: (context, GoRouterState state) {
        final permissionState = context.read<RequestPermissionBloc>().state;
        final bool isOnSplash = state.matchedLocation == AppRoutes.splash;
        final bool isOnPermissionPage =
            state.matchedLocation == AppRoutes.requestPermission;
        final bool hasCheckedPermissions =
            permissionState.hasCheckedPermissions;
        final bool allGranted = permissionState.allGranted;

        // While checking permissions, stay on splash screen
        if (!hasCheckedPermissions) {
          if (!isOnSplash) {
            return AppRoutes.splash;
          }
          return null; // Already on splash, stay there
        }

        // After permissions are checked, handle navigation
        if (hasCheckedPermissions) {
          // If permissions not granted and not on permission page, redirect to permission page
          if (!allGranted && !isOnPermissionPage) {
            return AppRoutes.requestPermission;
          }

          // If all permissions granted and on splash or permission page, go to home
          if (allGranted && (isOnSplash || isOnPermissionPage)) {
            return AppRoutes.home;
          }
        }

        return null;
      },
      routes: routes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'VibeZ',
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
