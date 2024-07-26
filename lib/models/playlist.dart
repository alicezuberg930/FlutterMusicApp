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
    if (json['artists'].isNotEmpty) json['artists'].forEach((artist) => tempArtists.add(Artist.fromJson(artist)));
    return Playlist(
      encodeId: json['encodeId'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      sortDescription: json['sortDescription'],
      artists: tempArtists,
      artistsNames: json['artistsNames'],
      thumbnailM: json['thumbnailM'],
      contentLastUpdate: json['contentLastUpdate'],
      songs: json.containsKey("song") && json['song']['items'] != null ? json['song']['items'].map((song) => Song.fromJson(song)).toList() : [],
    );
  }
}
