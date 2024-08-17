import 'package:flutter_music_app/models/artist.dart';
import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/models/video.dart';

class Section {
  String? sectionType;
  String? title;
  String? sectionId;
  List<dynamic> items = [];

  Section({this.sectionType, this.title, this.sectionId, required this.items});
  factory Section.fromJson(Map<String, dynamic> json) {
    List<Playlist> tempPlaylists = [];
    List<Song> tempSongs = [];
    List<Video> tempVideos = [];
    List<Artist> tempArtist = [];

    if (json["items"] != null && json["items"].isNotEmpty) {
      for (var item in (json['items'] as List)) {
        if (json['sectionType'] == "playlist") tempPlaylists.add(Playlist.fromJson(item));
        if (json['sectionType'] == "song") tempSongs.add(Song.fromJson(item));
        if (json['sectionType'] == "artist") tempArtist.add(Artist.fromJson(item));
        if (json['sectionType'] == "video") tempVideos.add(Video.fromJson(item));
      }
    }

    return Section(
      sectionType: json['sectionType'],
      title: json['title'],
      sectionId: json['sectionId'],
      items: tempPlaylists.isNotEmpty
          ? tempPlaylists
          : tempSongs.isNotEmpty
              ? tempSongs
              : tempVideos.isNotEmpty
                  ? tempVideos
                  : tempArtist,
    );
  }
}
