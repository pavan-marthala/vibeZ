// lib/core/features/shared/widgets/track_options_menu.dart
import 'package:flutter/material.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:music/core/features/utils/add_to_playlist_dialog.dart';
import 'package:music/core/features/utils/sized_context.dart';
import 'package:share_plus/share_plus.dart';

void showTrackOptionsMenu(BuildContext context, AudioTrack track) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => SafeArea(
      child: Container(
        height: 700,
        padding: EdgeInsets.only(bottom: context.viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.music_note),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          track.artist,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Options
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add to Playlist'),
              onTap: () {
                Navigator.pop(context);
                showAddToPlaylistDialog(context, track);
              },
            ),
            ListTile(
              leading: const Icon(Icons.queue_music),
              title: const Text('Add to Queue'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Add to queue
              },
            ),
            ListTile(
              leading: const Icon(Icons.album),
              title: const Text('Go to Album'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to album
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Go to Artist'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to artist
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                Share.share('Check out ${track.title} by ${track.artist}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Track Info'),
              onTap: () {
                Navigator.pop(context);
                _showTrackInfo(context, track);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

void _showTrackInfo(BuildContext context, AudioTrack track) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Track Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(label: 'Title', value: track.title),
          _InfoRow(label: 'Artist', value: track.artist),
          _InfoRow(label: 'Album', value: track.album),
          _InfoRow(label: 'Duration', value: _formatDuration(track.duration)),
          _InfoRow(label: 'Path', value: track.path),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}
