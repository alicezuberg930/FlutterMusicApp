import 'package:flutter_music_app/models/song.dart';

class Playlist {
  final String title;
  final List<Song> song;
  final String imageUrl;

  Playlist({required this.title, required this.song, required this.imageUrl});
}
