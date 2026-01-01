class AudioTrack {
  final String id;
  final String title;
  final String artist;
  final String album;
  final Duration duration;
  final String path;
  final String? artwork;

  const AudioTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.path,
    this.artwork,
  });
}
