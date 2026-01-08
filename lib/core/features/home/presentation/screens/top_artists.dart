import 'package:flutter/material.dart';
import 'package:music/core/database/database_helper.dart';
import 'package:music/core/features/shared/models/listening_stats.dart';
import 'package:music/core/features/utils/loading_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/routes/app_routes.dart';
import 'package:music/core/theme/app_theme.dart';

class TopArtists extends StatefulWidget {
  const TopArtists({super.key});

  @override
  State<TopArtists> createState() => _TopArtistsState();
}

class _TopArtistsState extends State<TopArtists> {
  late Future<List<ArtistStats>> _topArtistsFuture;

  @override
  void initState() {
    super.initState();
    _topArtistsFuture = DatabaseHelper.instance.getTopArtists(limit: 50);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Top Artists'),
        backgroundColor: colors.background,
        elevation: 0,
      ),
      body: FutureBuilder<List<ArtistStats>>(
        future: _topArtistsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: "Analyzing your taste...");
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading artists',
                style: TextStyle(color: colors.error),
              ),
            );
          }

          final artists = snapshot.data ?? [];

          if (artists.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: colors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No artists found',
                    style: context.theme.appTypography.titleMedium.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Listen to more music to discover your favorites!',
                    style: context.theme.appTypography.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: artists.length,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 100,
            ),
            itemBuilder: (context, index) {
              final artist = artists[index];
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surfaceLight,
                    border: Border.all(color: colors.border),
                  ),
                  child: Center(
                    child: Text(
                      '#${index + 1}',
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  artist.artist,
                  style: context.theme.appTypography.bodyLarge.copyWith(
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${artist.playCount} plays • ${artist.trackCount} tracks',
                  style: context.theme.appTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  _formatDuration(Duration(seconds: artist.totalPlayTime)), // Assuming seconds
                  style: context.theme.appTypography.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                onTap: () {
                  context.pushNamed(
                    AppRoutes.artistTracks,
                    extra: artist.artist,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h';
    }
    return '${duration.inMinutes}m';
  }
}
