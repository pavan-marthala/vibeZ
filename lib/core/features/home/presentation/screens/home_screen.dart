import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/features/folder_selection/bloc/folder_selection_bloc.dart';
import 'package:music/core/features/home/presentation/screens/widgets/empty_library.dart';
import 'package:music/core/features/home/presentation/screens/widgets/home_body.dart';
import 'package:music/core/features/home/presentation/screens/widgets/loading_widget.dart';
import 'package:music/core/features/shared/widgets/mini_player.dart';
import 'package:music/core/features/utils/gradient_background_painter.dart';
import 'package:music/core/routes/app_routes.dart';
import 'package:music/core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            child: Stack(
              children: [
                BlocConsumer<FolderSelectionBloc, FolderSelectionState>(
                  listener: (context, state) {
                    if (state.status == FolderSelectionStatus.error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.errorMessage ?? 'An error occurred',
                          ),
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

                    return HomeBody();
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: MiniPlayer(
                    onTap: () {
                      context.push(AppRoutes.player);
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
}
