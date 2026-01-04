import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/features/dashboard/presentation/widgets/app_navigation_bar.dart';
import 'package:music/core/features/shared/widgets/mini_player.dart';
import 'package:music/core/routes/app_routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          navigationShell,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppNavigationBar(
              miniPlayer: MiniPlayer(
                onTap: () {
                  context.push(AppRoutes.player);
                },
              ),
              selectedIndex: navigationShell.currentIndex,
              onTabSelected: (index) => navigationShell.goBranch(index),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: NavigationBar(
      //   selectedIndex: navigationShell.currentIndex,
      //   onDestinationSelected: (index) => navigationShell.goBranch(index),
      //   destinations: const [
      //     NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      //     NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
      //   ],
      // ),
    );
  }
}
