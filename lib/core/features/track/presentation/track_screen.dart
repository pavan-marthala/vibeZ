import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/folder_selection/bloc/folder_selection_bloc.dart';
import 'package:music/core/features/track/presentation/widgets/track_body.dart';
import 'package:music/core/features/utils/empty_library.dart';
import 'package:music/core/features/utils/gradient_background_painter.dart';
import 'package:music/core/features/utils/loading_widget.dart';

import '../../../theme/app_theme.dart';

class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key});

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
            child: BlocConsumer<FolderSelectionBloc, FolderSelectionState>(
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
                  return LoadingWidget(
                    message: "Loading your music library...",
                  );
                }

                if (state.folders.isEmpty) {
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

                return TrackBody();
              },
            ),
          ),
        ],
      ),
    );
  }
}
