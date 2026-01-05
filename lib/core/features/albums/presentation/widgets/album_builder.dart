import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:music/core/features/albums/presentation/widgets/album_card.dart';
import 'package:music/core/features/shared/models/album.dart';
import 'package:music/core/features/utils/sized_context.dart';

class AlbumBuilder extends StatelessWidget {
  const AlbumBuilder({super.key, required this.albums});

  final List<Album> albums;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      itemCount: albums.length,
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: context.viewInsets.bottom + 160,
      ),
      itemBuilder: (context, index) {
        final album = albums[index];
        return AlbumCard(album: album);
      },
    );
  }
}
