import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Playlists',
                        style: context.theme.appTypography.headlineMedium
                            .copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: colors.primary,
                        ),
                        onPressed: () => _showCreatePlaylistDialog(context),
                      ),
                    ],
                  ),
                ),

                // Playlist Grid
                Expanded(
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
                              content: Text(state.actionSuccess!),
                              backgroundColor: colors.success,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                        if (state.actionError != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.actionError!),
                              backgroundColor: colors.error,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                    buildWhen: (previous, current) {
                      if (current is PlaylistLoaded &&
                          previous is PlaylistLoaded) {
                        return current.playlists != previous.playlists ||
                            current.actionLoading != previous.actionLoading;
                      }
                      return true;
                    },
                    builder: (context, state) {
                      if (state is PlaylistLoading) {
                        return const LoadingWidget(
                          message: "Loading your playlists...",
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
                            title: 'No Playlists Yet',
                            subtitle:
                                'Create your first playlist to organize your favorite tracks',
                            icon: Icons.playlist_play_rounded,
                            buttonText: 'Create Playlist',
                            onButtonPressed: () =>
                                _showCreatePlaylistDialog(context),
                          );
                        }

                        return Stack(
                          children: [
                            MasonryGridView.count(
                              crossAxisCount: 2,
                              itemCount: state.playlists.length,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: context.viewInsets.bottom + 160,
                              ),
                              itemBuilder: (context, index) {
                                final playlist = state.playlists[index];
                                return _PlaylistCard(
                                  playlist: playlist,
                                  onTap: () {
                                    // TODO: Navigate to playlist details
                                    context.read<PlaylistBloc>().add(
                                      GetById(playlist.id!),
                                    );
                                  },
                                  onDelete: playlist.isDefault
                                      ? null
                                      : () => _showDeleteDialog(
                                          context,
                                          playlist,
                                        ),
                                  onEdit: playlist.isDefault
                                      ? null
                                      : () => _showEditPlaylistDialog(
                                          context,
                                          playlist,
                                        ),
                                );
                              },
                            ),

                            // Loading overlay
                            if (state.actionLoading)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }

                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create Playlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Playlist Name',
                hintText: 'My Awesome Playlist',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'A collection of my favorite songs',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                context.read<PlaylistBloc>().add(
                  CreatePlayList(
                    name: name,
                    description: descriptionController.text.trim().isEmpty
                        ? null
                        : descriptionController.text.trim(),
                  ),
                );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditPlaylistDialog(BuildContext context, dynamic playlist) {
    final nameController = TextEditingController(text: playlist.name);
    final descriptionController = TextEditingController(
      text: playlist.description ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Playlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Playlist Name'),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                context.read<PlaylistBloc>().add(
                  Update(
                    playlist.copyWith(
                      name: name,
                      description: descriptionController.text.trim().isEmpty
                          ? null
                          : descriptionController.text.trim(),
                    ),
                  ),
                );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, dynamic playlist) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Playlist'),
        content: Text(
          'Are you sure you want to delete "${playlist.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<PlaylistBloc>().add(Delete(playlist.id!));
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _PlaylistCard extends StatelessWidget {
  final dynamic playlist;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const _PlaylistCard({
    required this.playlist,
    required this.onTap,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final isFavorites = playlist.isDefault;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: isFavorites
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.primary.withValues(alpha: 0.3),
                    colors.primary.withValues(alpha: 0.1),
                  ],
                )
              : null,
          color: isFavorites ? null : colors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isFavorites ? colors.primary : colors.border,
            width: isFavorites ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isFavorites
                          ? colors.primary.withValues(alpha: 0.3)
                          : colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isFavorites
                          ? Icons.favorite
                          : Icons.playlist_play_rounded,
                      size: 30,
                      color: isFavorites
                          ? colors.primary
                          : colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    playlist.name,
                    style: context.theme.appTypography.titleMedium.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Description or track count
                  Text(
                    playlist.description ?? '${playlist.trackCount} tracks',
                    style: context.theme.appTypography.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Track count badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${playlist.trackCount} songs',
                      style: context.theme.appTypography.labelSmall.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Menu button (only for non-default playlists)
            if (!isFavorites)
              Positioned(
                top: 8,
                right: 8,
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: colors.textSecondary,
                    size: 20,
                  ),
                  onSelected: (value) {
                    if (value == 'edit' && onEdit != null) {
                      onEdit!();
                    } else if (value == 'delete' && onDelete != null) {
                      onDelete!();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
