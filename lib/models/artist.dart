import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/models/section.dart';

class Artist {
  String? id;
  String? name;
  String? link;
  String? thumbnail;
  String? thumbnailM;
  int? totalFollow;
  String? alias;
  String? biography;
  String? national;
  String? birthday;
  String? realname;
  Playlist? topAlbum;
  List<Section>? sections = [];

  Artist({
    this.id,
    this.name,
    this.link,
    this.thumbnail,
    this.thumbnailM,
    this.totalFollow,
    this.alias,
    this.biography,
    this.national,
    this.birthday,
    this.realname,
    this.topAlbum,
    this.sections,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    List<Section> tempSections = [];
    if (json['sections'] != null) json['sections'].forEach((section) => tempSections.add(Section.fromJson(section)));

    return Artist(
      id: json['id'],
      name: json['name'],
      link: json['link'],
      thumbnail: json['thumbnail'],
      thumbnailM: json['thumbnailM'],
      totalFollow: json['totalFollow'],
      alias: json['alias'],
      biography: json['biography'],
      national: json['national'],
      birthday: json['birthday'],
      realname: json['realname'],
      topAlbum: json['topAlbum'] != null ? Playlist.fromJson(json['topAlbum']) : null,
      sections: tempSections,
    );
  }

  toJson() {
    return {
      "id": id,
      "name": name,
      "link": link,
      "thumbnail": thumbnail,
      "thumbnailM": thumbnailM,
      "totalFollow": totalFollow,
      "alias": alias,
      "biography": biography,
      "national": national,
      "birthday": birthday,
      "realname": realname,
    };
  }
}
