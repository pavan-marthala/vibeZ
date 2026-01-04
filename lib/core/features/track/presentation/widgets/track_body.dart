import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/folder_selection/bloc/folder_selection_bloc.dart';
import 'package:music/core/features/shared/bloc/music_library/music_library_bloc.dart';
import 'package:music/core/features/track/presentation/widgets/track_builder.dart';
import 'package:music/core/features/utils/empty_tracks.dart';
import 'package:music/core/features/utils/error_widget.dart';
import 'package:music/core/features/utils/loading_widget.dart';

class TrackBody extends StatelessWidget {
  const TrackBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicLibraryBloc, MusicLibraryState>(
      builder: (context, libraryState) {
        if (libraryState is MusicLibraryLoading) {
          return const LoadingWidget(message: "Scanning for music files...");
        }
        if (libraryState is MusicLibraryError) {
          return PremiumErrorState(
            title: 'Oops! Something Went Wrong',
            message: libraryState.message,
            buttonText: 'Try Again',
            icon: Icons.cloud_off_rounded,
            onRetry: () {
              context.read<MusicLibraryBloc>().add(LoadAudioFiles());
            },
          );
        }

        if (libraryState is! MusicLibraryLoaded) {
          return const SizedBox();
        }

        if (libraryState.tracks.isEmpty) {
          return NoMusicFoundState(
            onAddFolder: () async {
              context.read<FolderSelectionBloc>().add(AddFolder());
            },
          );
        }

        return TrackBuilder(libraryState: libraryState);
      },
    );
  }
}
