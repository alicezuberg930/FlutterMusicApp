import 'package:flutter_music_app/models/artist.dart';
import 'package:flutter_music_app/models/song.dart';

class Playlist {
  String? encodeId;
  String? title;
  String? thumbnail;
  String? sortDescription;
  List<Artist>? artists = [];
  String? artistsNames;
  String? thumbnailM;
  int? contentLastUpdate;
  List<Song> songs = [];

  Playlist({
    this.encodeId,
    this.title,
    this.thumbnail,
    this.sortDescription,
    this.artists,
    this.artistsNames,
    this.thumbnailM,
    this.contentLastUpdate,
    required this.songs,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    List<Artist> tempArtists = [];
    List<Song> tempSongs = [];
    if (json['artists'].isNotEmpty) json['artists'].forEach((artist) => tempArtists.add(Artist.fromJson(artist)));
    if (json["song"] != null && json['song']['items'].isNotEmpty) json['song']['items'].forEach((song) => tempSongs.add(Song.fromJson(song)));

    return Playlist(
      encodeId: json['encodeId'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      sortDescription: json['sortDescription'],
      artists: tempArtists,
      artistsNames: json['artistsNames'],
      thumbnailM: json['thumbnailM'],
      contentLastUpdate: json['contentLastUpdate'],
      songs: tempSongs,
    );
  }
}
