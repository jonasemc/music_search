class MusicModel {
  final int id;
  final String title;
  final String album;
  final String artist;

  MusicModel({
    required this.id,
    required this.title,
    required this.album,
    required this.artist,
  });

  factory MusicModel.fromMap(Map<String, dynamic> map) {
    return MusicModel(
        id: map['track_id'],
        title: map['track_name'],
        album: map['album_name'],
        artist: map['artist_name']);
  }
}
