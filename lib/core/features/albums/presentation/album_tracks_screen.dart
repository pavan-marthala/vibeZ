import 'package:flutter/material.dart';

class AlbumTracksScreen extends StatelessWidget {
  const AlbumTracksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(child: Text('This is AlbumTracksScreen'));
          },
        ),
      ),
    );
  }
}
