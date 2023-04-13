import 'package:flutter_music_app/models/song.dart';

class Playlist {
  final String title;
  final List<Song> song;
  final String imageUrl;

  Playlist({required this.title, required this.song, required this.imageUrl});
  static List<Playlist> playlists = [
    Playlist(
      title: "My List 1",
      song: Song.songs,
      imageUrl: "assets/image/Daniel_Park_UI.jpg",
    ),
    Playlist(
      title: "My List 2",
      song: Song.songs,
      imageUrl: "assets/image/Kwak_Jichang.jpg",
    ),
    Playlist(
      title: "My List 3",
      song: Song.songs,
      imageUrl: "assets/image/OG_Daniel_After_Training_Fight.jpg",
    ),
    Playlist(
      title: "My List 4",
      song: Song.songs,
      imageUrl: "assets/image/Park_Jong_Gun.jpg",
    ),
    Playlist(
      title: "My List 5",
      song: Song.songs,
      imageUrl: "assets/image/Park_Jong_Gun.jpg",
    )
  ];
}
