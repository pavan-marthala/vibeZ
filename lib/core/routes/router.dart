import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/features/albums/presentation/albums_screen.dart';
import 'package:music/core/features/dashboard/presentation/dashboard_screen.dart';
import 'package:music/core/features/folder_selection/screens/folder_selection_screen.dart';
import 'package:music/core/features/home/presentation/screens/home_screen.dart';
import 'package:music/core/features/player/presentation/screens/full_screen_player.dart';
import 'package:music/core/features/playlist/presentation/playlist_screen.dart';
import 'package:music/core/features/request_permission/screens/request_permission_screen.dart';
import 'package:music/core/features/settings/screens/settings_screen.dart';
import 'package:music/core/features/splash/splash_screen.dart';
import 'package:music/core/routes/app_routes.dart';

import '../features/track/presentation/track_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final GlobalKey<NavigatorState> _shellNavigatorKeyHome =
    GlobalKey<NavigatorState>(debugLabel: 'shell-home');
final GlobalKey<NavigatorState> _shellNavigatorKeySettings =
    GlobalKey<NavigatorState>(debugLabel: 'shell-settings');
final GlobalKey<NavigatorState> _shellNavigatorKeyPlayList =
    GlobalKey<NavigatorState>(debugLabel: 'shell-playlist');
final GlobalKey<NavigatorState> _shellNavigatorKeyTracks =
    GlobalKey<NavigatorState>(debugLabel: 'shell-tracks');
final GlobalKey<NavigatorState> _shellNavigatorKeyAlbums =
    GlobalKey<NavigatorState>(debugLabel: 'shell-albums');

final routes = [
  GoRoute(
    path: AppRoutes.splash,
    name: AppRoutes.splash,
    builder: (context, state) => const SplashScreen(),
  ),
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return DashboardScreen(navigationShell: navigationShell);
    },
    branches: [
      StatefulShellBranch(
        navigatorKey: _shellNavigatorKeyHome,
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: AppRoutes.home,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: HomeScreen()),
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: _shellNavigatorKeyAlbums,
        routes: [
          GoRoute(
            path: AppRoutes.albums,
            name: AppRoutes.albums,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: AlbumsScreen()),
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: _shellNavigatorKeyTracks,
        routes: [
          GoRoute(
            path: AppRoutes.tracks,
            name: AppRoutes.tracks,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: TrackScreen()),
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: _shellNavigatorKeyPlayList,
        routes: [
          GoRoute(
            path: AppRoutes.playlist,
            name: AppRoutes.playlist,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: PlaylistScreen()),
          ),
        ],
      ),

      StatefulShellBranch(
        navigatorKey: _shellNavigatorKeySettings,
        routes: [
          GoRoute(
            path: AppRoutes.settings,
            name: AppRoutes.settings,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: SettingsScreen()),
          ),
        ],
      ),
    ],
  ),
  GoRoute(
    path: AppRoutes.requestPermission,
    name: AppRoutes.requestPermission,
    builder: (context, state) => const RequestPermissionScreen(),
  ),
  GoRoute(
    path: AppRoutes.folderSelection,
    name: AppRoutes.folderSelection,
    builder: (context, state) => const FolderSelectionScreen(),
  ),
  GoRoute(
    path: AppRoutes.player,
    name: AppRoutes.player,
    builder: (context, state) => const FullScreenPlayer(),
  ),
];
