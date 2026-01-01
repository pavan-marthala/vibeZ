import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/folder_selection/bloc/folder_selection_bloc.dart';
import 'package:music/core/features/shared/models/folder_model.dart';

class FolderSelectionScreen extends StatelessWidget {
  const FolderSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Music Folders'),
        actions: [
          BlocBuilder<FolderSelectionBloc, FolderSelectionState>(
            builder: (context, state) {
              if (state.folders.isEmpty) return const SizedBox.shrink();

              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'clear') {
                    _showClearConfirmDialog(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'clear',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Clear All Folders'),
                      ],
                    ),
                  ),
                ],
              );
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

          return Column(
            children: [
              // Folder count header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.deepPurple.withOpacity(0.1),
                child: Text(
                  '${state.folders.length} folder(s) selected',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Folder list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.folders.length,
                  itemBuilder: (context, index) {
                    final folder = state.folders[index];
                    return _FolderCard(folder: folder);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<FolderSelectionBloc>().add(AddFolder());
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Folder'),
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

  void _showClearConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear All Folders?'),
        content: const Text(
          'This will remove all selected folders from your library. Your music files will not be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<FolderSelectionBloc>().add(ClearAllFolders());
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

class _FolderCard extends StatelessWidget {
  final FolderModel folder;

  const _FolderCard({required this.folder});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.folder, color: Colors.deepPurple, size: 28),
        ),
        title: Text(
          folder.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              folder.path,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'Added ${_formatDate(folder.addedAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            _showDeleteDialog(context, folder);
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, FolderModel folder) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove Folder?'),
        content: Text(
          'Remove "${folder.name}" from your library? Your music files will not be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<FolderSelectionBloc>().add(RemoveFolder(folder.id!));
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
