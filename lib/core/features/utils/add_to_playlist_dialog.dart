import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/database/database_helper.dart';
import 'package:music/core/features/playlist/presentation/bloc/playlist_bloc.dart';
import 'package:music/core/features/shared/models/audio_track.dart';

class AddToPlaylistDialog extends StatelessWidget {
  final AudioTrack track;

  const AddToPlaylistDialog({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        if (state is PlaylistLoading) {
          return const AlertDialog(
            title: Text('Add to Playlist'),
            content: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is PlaylistLoaded) {
          // Filter out playlists that already contain this track
          return FutureBuilder<List<bool>>(
            future: Future.wait(
              state.playlists.map(
                (p) =>
                    DatabaseHelper.instance.isTrackInPlaylist(p.id!, track.id),
              ),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const AlertDialog(
                  title: Text('Add to Playlist'),
                  content: Center(child: CircularProgressIndicator()),
                );
              }

              final trackInPlaylists = snapshot.data!;

              return AlertDialog(
                title: const Text('Add to Playlist'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = state.playlists[index];
                      final alreadyInPlaylist = trackInPlaylists[index];

                      return ListTile(
                        leading: Icon(
                          playlist.isDefault
                              ? Icons.favorite
                              : Icons.playlist_play,
                          color: alreadyInPlaylist ? Colors.green : null,
                        ),
                        title: Text(playlist.name),
                        subtitle: Text('${playlist.trackCount} songs'),
                        trailing: alreadyInPlaylist
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : null,
                        enabled: !alreadyInPlaylist,
                        onTap: alreadyInPlaylist
                            ? null
                            : () {
                                context.read<PlaylistBloc>().add(
                                  AddTrack(
                                    playlistId: playlist.id!,
                                    trackId: track.id,
                                  ),
                                );
                                Navigator.pop(context);
                              },
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showCreatePlaylistDialog(context, track);
                    },
                    child: const Text('New Playlist'),
                  ),
                ],
              );
            },
          );
        }

        return const AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load playlists'),
        );
      },
    );
  }

  void _showCreatePlaylistDialog(BuildContext context, AudioTrack track) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create Playlist'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Playlist Name',
            hintText: 'My Awesome Playlist',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                // Create playlist
                final playlist = await DatabaseHelper.instance.createPlaylist(
                  name,
                );

                // Add track to new playlist
                if (context.mounted) {
                  context.read<PlaylistBloc>().add(
                    AddTrack(playlistId: playlist.id!, trackId: track.id),
                  );
                }

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              }
            },
            child: const Text('Create & Add'),
          ),
        ],
      ),
    );
  }
}

// Helper function to show the dialog
void showAddToPlaylistDialog(BuildContext context, AudioTrack track) {
  showDialog(
    context: context,
    builder: (context) => AddToPlaylistDialog(track: track),
  );
}
