import 'package:flutter_music_app/models/artist.dart';

class Song {
  String? encodeId;
  String? title;
  String? artistsNames;
  List<Artist>? artists;
  String? thumbnailM;
  String? thumbnail;
  String? link;
  int? duration;
  int? releaseDate;
  List<dynamic>? genreIds;
  bool? hasLyric;
  String? q128;

  Song({
    this.encodeId,
    this.title,
    this.artistsNames,
    this.artists,
    this.thumbnailM,
    this.thumbnail,
    this.link,
    this.duration,
    this.releaseDate,
    this.genreIds,
    this.hasLyric,
    this.q128,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    List<Artist> tempArtists = [];
    if (json['artists'] != null && json['artists'].isNotEmpty) json['artists'].forEach((artist) => tempArtists.add(Artist.fromJson(artist)));

    return Song(
      encodeId: json['encodeId'],
      title: json['title'],
      artistsNames: json['artistsNames'],
      artists: tempArtists,
      thumbnailM: json['thumbnailM'],
      thumbnail: json['thumbnail'],
      link: json['link'],
      duration: json['duration'],
      releaseDate: json['releaseDate'],
      genreIds: json['genreIds'],
      hasLyric: json['hasLyric'],
      q128: json['streaming'] == null ? null : json['streaming']['128'],
    );
  }

  toJson() {
    return {
      "encodeId": encodeId,
      "title": title,
      "artistsNames": artistsNames,
      "thumbnailM": thumbnailM,
      "link": link,
      "duration": duration,
      "genreIds": genreIds,
      "artists": artists?.map((artist) => artist.toJson()).toList(),
    };
  }
}
