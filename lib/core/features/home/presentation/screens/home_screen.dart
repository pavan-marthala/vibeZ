import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/folder_selection/bloc/folder_selection_bloc.dart';
import 'package:music/core/features/shared/bloc/audio_player/audio_player_bloc.dart';
import 'package:music/core/features/shared/bloc/music_library/music_library_bloc.dart';
import 'package:music/core/features/shared/bloc/stats_bloc_bloc/stats_bloc.dart';
import 'package:music/core/features/shared/models/listening_stats.dart';
import 'package:music/core/features/utils/loading_widget.dart';
import 'package:music/core/features/utils/sized_context.dart';
import 'package:music/core/theme/app_colors.dart';
import 'package:music/core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return BlocListener<MusicLibraryBloc, MusicLibraryState>(
      listener: (context, state) {
        if (state is MusicLibraryLoaded && state.tracks.isNotEmpty) {
          context.read<AudioPlayerBloc>().add(
            RestoreLastPlayback(state.tracks),
          );
        }
      },
      child: Scaffold(
        backgroundColor: colors.background,
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<StatsBloc>().add(RefreshStats());
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                centerTitle: true,
                backgroundColor: colors.background,
                title: const Text('vibeZ'),
                actions: [
                  IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                ],
              ),
              const _StatsSection(),
              const _RecentlyPlayedSection(),
              const _TopTracksSection(),
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: context.viewInsets.bottom + 160,
                ),
                sliver: const _TopArtistsSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        if (state is StatsLoading) {
          return const SliverToBoxAdapter(
            child: LoadingWidget(message: "Loading stats..."),
          );
        }

        if (state is StatsError) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _EmptyStateCard(
                icon: Icons.error_outline,
                title: 'Error loading stats',
                subtitle: state.message,
              ),
            ),
          );
        }

        if (state is! StatsLoaded) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _EmptyStateCard(
                icon: Icons.music_note,
                title: 'Start listening',
                subtitle: 'Your stats will appear here as you play music',
                action: BlocBuilder<FolderSelectionBloc, FolderSelectionState>(
                  builder: (context, folderState) {
                    if (folderState.folders.isEmpty) {
                      return ElevatedButton.icon(
                        onPressed: () {
                          context.read<FolderSelectionBloc>().add(AddFolder());
                        },
                        icon: const Icon(Icons.folder_open),
                        label: const Text('Add Music Folder'),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          );
        }

        final stats = state.stats;
        final colors = context.theme.appColors;

        return SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Stats',
                  style: context.theme.appTypography.headlineSmall.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.play_circle_outline,
                        value: '${stats.totalPlays}',
                        label: 'Total Plays',
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.access_time,
                        value: _formatDuration(stats.totalListeningTime),
                        label: 'Listening Time',
                        color: colors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.library_music,
                        value: '${stats.uniqueTracks}',
                        label: 'Unique Tracks',
                        color: colors.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.person_outline,
                        value: '${stats.uniqueArtists}',
                        label: 'Artists',
                        color: colors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) return '${(seconds / 60).round()}m';
    return '${(seconds / 3600).toStringAsFixed(1)}h';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: context.theme.appTypography.headlineMedium.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: context.theme.appTypography.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentlyPlayedSection extends StatelessWidget {
  const _RecentlyPlayedSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        if (state is! StatsLoaded || state.stats.recentHistory.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        final colors = context.theme.appColors;
        final history = state.stats.recentHistory;

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recently Played',
                      style: context.theme.appTypography.titleLarge.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to full history
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(color: colors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: history.length > 10 ? 10 : history.length,
                  itemBuilder: (context, index) {
                    final track = history[index];
                    return _RecentTrackCard(track: track);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RecentTrackCard extends StatelessWidget {
  final dynamic track;

  const _RecentTrackCard({required this.track});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        color: colors.surfaceLight,
        child: InkWell(
          onTap: () {
            // TODO: Play this track
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: track.albumArtPath != null
                      ? Image.file(
                          File(track.albumArtPath!),
                          width: double.infinity,
                          height: 80,
                          alignment: .topCenter,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildDefaultArt(colors),
                        )
                      : _buildDefaultArt(colors),
                ),
                const SizedBox(height: 8),
                Text(
                  track.trackTitle,
                  style: context.theme.appTypography.bodyMedium.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  track.artist,
                  style: context.theme.appTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopTracksSection extends StatelessWidget {
  const _TopTracksSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        if (state is! StatsLoaded || state.stats.topTracks.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        final colors = context.theme.appColors;
        final tracks = state.stats.topTracks;

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Text(
                  'Top Tracks',
                  style: context.theme.appTypography.titleLarge.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tracks.length > 5 ? 5 : tracks.length,
                itemBuilder: (context, index) {
                  final track = tracks[index];
                  return _TopTrackItem(rank: index + 1, track: track);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopTrackItem extends StatelessWidget {
  final int rank;
  final TrackStats track;

  const _TopTrackItem({required this.rank, required this.track});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: track.albumArtPath != null
                  ? Image.file(
                      File(track.albumArtPath!),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildDefaultArt(colors),
                    )
                  : _buildDefaultArt(colors),
            ),
          ],
        ),
        title: Text(
          track.title,
          style: context.theme.appTypography.bodyMedium.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${track.artist} • ${track.playCount} plays',
          style: context.theme.appTypography.bodySmall.copyWith(
            color: colors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(Icons.play_circle_filled, color: colors.primary),
          onPressed: () {
            // TODO: Play this track
          },
        ),
      ),
    );
  }
}

Widget _buildDefaultArt(AppColors colors) {
  return Container(
    width: 48,
    height: 48,
    color: colors.primary.withValues(alpha: 0.2),
    child: Icon(Icons.music_note, color: colors.primary, size: 24),
  );
}

class _TopArtistsSection extends StatelessWidget {
  const _TopArtistsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        if (state is! StatsLoaded || state.stats.topArtists.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        final colors = context.theme.appColors;
        final artists = state.stats.topArtists;

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Text(
                  'Top Artists',
                  style: context.theme.appTypography.titleLarge.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: artists.length,
                  itemBuilder: (context, index) {
                    final artist = artists[index];
                    return _TopArtistCard(rank: index + 1, artist: artist);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopArtistCard extends StatelessWidget {
  final int rank;
  final dynamic artist;

  const _TopArtistCard({required this.rank, required this.artist});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return SizedBox(
      width: 130,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colors.primary,
                          colors.primary.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                    child: Icon(Icons.person, size: 50, color: colors.white),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: rank <= 3 ? colors.primary : colors.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$rank',
                      style: context.theme.appTypography.labelSmall.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                artist.artist,
                style: context.theme.appTypography.bodyMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              // const SizedBox(height: 4),
              // Text(
              //   '${artist.playCount} plays',
              //   style: context.theme.appTypography.bodySmall.copyWith(
              //     color: colors.textSecondary,
              //   ),
              // ),
              // Text(
              //   '${artist.trackCount} tracks',
              //   style: context.theme.appTypography.bodySmall.copyWith(
              //     color: colors.textSecondary,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const _EmptyStateCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 64, color: colors.textSecondary),
          const SizedBox(height: 16),
          Text(
            title,
            style: context.theme.appTypography.titleLarge.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: context.theme.appTypography.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[const SizedBox(height: 24), action!],
        ],
      ),
    );
  }
}
