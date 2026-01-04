import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/features/folder_selection/screens/folder_selection_screen.dart';
import 'package:music/core/features/home/presentation/screens/home_screen.dart';
import 'package:music/core/features/player/presentation/screens/full_screen_player.dart';
import 'package:music/core/features/request_permission/screens/request_permission_screen.dart';
import 'package:music/core/features/settings/screens/settings_screen.dart';
import 'package:music/core/features/splash/splash_screen.dart';
import 'package:music/core/routes/app_routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

// final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
//   debugLabel: 'shell',
// );

final routes = [
  GoRoute(
    path: AppRoutes.splash,
    name: AppRoutes.splash,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: AppRoutes.home,
    name: AppRoutes.home,
    builder: (context, state) => const HomeScreen(),
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
    path: AppRoutes.settings,
    name: AppRoutes.settings,
    builder: (context, state) => const SettingsScreen(),
  ),
  GoRoute(
    path: AppRoutes.player,
    name: AppRoutes.player,
    builder: (context, state) => const FullScreenPlayer(),
  ),
];
