import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/features/dashboard/presentation/widgets/app_navigation_bar.dart';
import 'package:music/core/features/shared/widgets/mini_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/folder_selection/bloc/folder_selection_bloc.dart';
import 'package:music/core/features/shared/bloc/music_library/music_library_bloc.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/track/presentation/widgets/track_search_delegate.dart';
import 'package:music/core/routes/app_routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VibeZ'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TrackSearchDelegate(
                  musicLibraryBloc: context.read<MusicLibraryBloc>(),
                  audioPlayerBloc: context.read<AudioPlayerBloc>(),
                ),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: BlocListener<FolderSelectionBloc, FolderSelectionState>(
        listener: (context, state) {
          if (state.status == FolderSelectionStatus.success) {
            context.read<MusicLibraryBloc>().add(LoadAudioFiles());
          }
        },
        child: Stack(
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
