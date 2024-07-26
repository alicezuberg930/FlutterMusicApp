import 'package:flutter_music_app/models/playlist.dart';

class Top100 {
  String? sectionType;
  String? title;
  List<Playlist> items = [];

  Top100({this.sectionType, this.title, required this.items});
  factory Top100.fromJson(Map<String, dynamic> json) {
    List<Playlist> tempPlaylists = [];
    if (json["items"].isNotEmpty) json['items'].forEach((item) => tempPlaylists.add(Playlist.fromJson(item)));
    return Top100(
      sectionType: json['sectionType'],
      title: json['title'],
      items: tempPlaylists,
    );
  }
}
