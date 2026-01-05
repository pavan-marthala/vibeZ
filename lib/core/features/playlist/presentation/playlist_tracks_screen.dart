import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/features/playlist/presentation/bloc/playlist_bloc.dart';

class PlaylistTracksScreen extends StatelessWidget {
  const PlaylistTracksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PlaylistBloc, PlaylistState>(
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Center(child: Text('This is PlaylistTracksScreen'));
              },
            );
          },
        ),
      ),
    );
  }
}
