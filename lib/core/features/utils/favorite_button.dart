import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/database/database_helper.dart';
import 'package:music/core/features/playlist/presentation/bloc/playlist_bloc.dart';
import 'package:music/core/features/shared/models/audio_track.dart';

class FavoriteButton extends StatefulWidget {
  final AudioTrack track;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const FavoriteButton({
    super.key,
    required this.track,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  @override
  void didUpdateWidget(FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.track.id != widget.track.id) {
      _checkIfFavorite();
    }
  }

  Future<void> _checkIfFavorite() async {
    try {
      final isFav = await DatabaseHelper.instance.isTrackInFavorites(
        widget.track.id,
      );
      if (mounted) {
        setState(() => _isFavorite = isFav);
      }
    } catch (e) {
      print('Error checking favorite: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // Toggle via bloc for proper state management
      context.read<PlaylistBloc>().add(ToggleFavorite(widget.track.id));

      // Update local state
      setState(() {
        _isFavorite = !_isFavorite;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? Colors.red;
    final inactiveColor = widget.inactiveColor ?? Colors.grey;

    return IconButton(
      icon: _isLoading
          ? SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: activeColor,
              ),
            )
          : Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? activeColor : inactiveColor,
              size: widget.size,
            ),
      onPressed: _toggleFavorite,
    );
  }
}
