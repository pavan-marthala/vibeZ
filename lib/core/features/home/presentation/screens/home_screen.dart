import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/features/folder_selection/bloc/folder_selection_bloc.dart';
import 'package:music/core/features/shared/bloc/music_library/bloc/music_library_bloc.dart';
import 'package:music/core/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: BlocConsumer<FolderSelectionBloc, FolderSelectionState>(
        listener: (context, state) {
          if (state.status == FolderSelectionStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == FolderSelectionStatus.loading &&
              state.folders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.folders.isEmpty) {
            return _buildEmptyState(context);
          }

          return BlocBuilder<MusicLibraryBloc, MusicLibraryState>(
            builder: (context, state) {
              if (state is MusicLibraryLoading) {
                return Center(child: const CircularProgressIndicator());
              }

              if (state is MusicLibraryLoaded) {
                return ListView.builder(
                  itemCount: state.tracks.length,
                  itemBuilder: (_, i) {
                    final track = state.tracks[i];
                    return ListTile(
                      title: Text(track.title),
                      onTap: () {
                        // context.read<AudioPlayerBloc>().add(PlayTrack(track));
                      },
                    );
                  },
                );
              }

              return const SizedBox();
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 120, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'No Folders Selected',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add folders containing your music files to get started',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.read<FolderSelectionBloc>().add(AddFolder());
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Folder'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
