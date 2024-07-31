import 'package:flutter_music_app/models/artist.dart';
import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/models/video.dart';

class Search {
  List<Song> songs = [];
  List<Artist> artists = [];
  List<Playlist> playlists = [];
  List<Video> videos = [];

  Search({
    required this.songs,
    required this.artists,
    required this.playlists,
    required this.videos,
  });

  factory Search.fromJson(Map<String, dynamic> json) {
    List<Song> tempSongs = [];
    List<Artist> tempArtists = [];
    List<Playlist> tempPlaylists = [];
    List<Video> tempVideos = [];

    if (json['songs'] != null && json['songs'].isNotEmpty) json['songs'].forEach((song) => tempSongs.add(Song.fromJson(song)));
    if (json['artists'] != null && json['artists'].isNotEmpty) json['artists'].forEach((artist) => tempArtists.add(Artist.fromJson(artist)));
    if (json['playlists'] != null && json['playlists'].isNotEmpty) json['playlists'].forEach((playlist) => tempPlaylists.add(Playlist.fromJson(playlist)));
    if (json['videos'] != null && json['videos'].isNotEmpty) json['videos'].forEach((video) => tempVideos.add(Video.fromJson(video)));

    return Search(
      songs: tempSongs,
      artists: tempArtists,
      playlists: tempPlaylists,
      videos: tempVideos,
    );
  }
}
