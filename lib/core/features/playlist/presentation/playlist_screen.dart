import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:music/core/features/folder_selection/bloc/folder_selection_bloc.dart';
import 'package:music/core/features/playlist/presentation/bloc/playlist_bloc.dart';
import 'package:music/core/features/utils/empty_library.dart';
import 'package:music/core/features/utils/error_widget.dart';
import 'package:music/core/features/utils/gradient_background_painter.dart';
import 'package:music/core/features/utils/loading_widget.dart';
import 'package:music/core/features/utils/sized_context.dart';
import 'package:music/core/theme/app_theme.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: GradientBackgroundPainter(colors: colors),
            child: Container(),
          ),
          SafeArea(
            bottom: false,
            child: BlocConsumer<PlaylistBloc, PlaylistState>(
              listenWhen: (previous, current) {
                return current is PlaylistLoaded &&
                    (current.actionSuccess != null ||
                        current.actionError != null);
              },
              listener: (context, state) {
                if (state is PlaylistLoaded) {
                  if (state.actionSuccess != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.actionError!),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  if (state.actionError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.actionError!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              buildWhen: (previous, current) {
                if (current is PlaylistLoaded && previous is PlaylistLoaded) {
                  return current.playlists != previous.playlists ||
                      current.actionLoading != previous.actionLoading;
                }
                return true;
              },
              builder: (context, state) {
                if (state is PlaylistLoading) {
                  return LoadingWidget(
                    message: "Loading your music playlist...",
                  );
                }
                if (state is PlaylistError) {
                  return ErrorState(
                    message: state.message,
                    onRetry: () {
                      context.read<PlaylistBloc>().add(FetchPlayList());
                    },
                  );
                }
                if (state is PlaylistLoaded) {
                  if (state.playlists.isEmpty) {
                    return PremiumEmptyState(
                      title: 'No Folders Selected',
                      subtitle:
                          'Add folders containing your music files to start your musical journey',
                      icon: Icons.folder_open_rounded,
                      buttonText: 'Add Your First Folder',
                      onButtonPressed: () {
                        context.read<FolderSelectionBloc>().add(AddFolder());
                      },
                    );
                  }

                  return MasonryGridView.count(
                    crossAxisCount: 2,
                    itemCount: state.playlists.length,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: context.viewInsets.bottom + 160,
                    ),
                    itemBuilder: (context, index) {
                      final playList = state.playlists[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.surfaceLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.border, width: 1),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.playlist_add_check_outlined, size: 40),
                            const SizedBox(height: 16),
                            Text(playList.name),
                            const SizedBox(height: 8),
                            Text(playList.trackCount.toString()),
                          ],
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
