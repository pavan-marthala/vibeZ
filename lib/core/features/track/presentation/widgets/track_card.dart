import 'package:flutter/material.dart';
import 'package:music/core/features/shared/models/audio_track.dart';
import 'package:music/core/features/utils/app_utils.dart';

class TrackCard extends StatelessWidget {
  const TrackCard({
    super.key,
    required this.isPlayingThisTrack,
    required this.track,
    required this.onPlayPause,
    required this.onTap,
    required this.isPlaying,
  });

  final bool isPlayingThisTrack;
  final AudioTrack track;
  final Function() onPlayPause;
  final Function() onTap;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isPlayingThisTrack ? Colors.white.withValues(alpha: 0.4) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            spacing: 6,
            children: [
              buildAlbumArt(track),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isPlayingThisTrack
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      track.artist,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isPlayingThisTrack && isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 36,
                  color: Colors.white,
                ),
                onPressed: onPlayPause,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
