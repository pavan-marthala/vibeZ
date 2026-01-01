import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/features/home/presentation/screens/home_screen.dart';
import 'package:music/core/features/request_permission/screens/request_permission.dart';
import 'package:music/core/routes/app_routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.requestPermission,
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.requestPermission,
      name: AppRoutes.requestPermission,
      builder: (context, state) => const RequestPermission(),
    ),
  ],
);
