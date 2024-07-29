import 'package:flutter_music_app/models/artist.dart';
import 'package:flutter_music_app/models/song.dart';

class Video extends Song {
  Video({
    String? encodeId,
    String? title,
    String? artistsNames,
    List<Artist>? artists,
    String? thumbnailM,
    String? thumbnail,
    String? link,
    int? duration,
    int? releaseDate,
    List<dynamic>? genreIds,
    bool? hasLyric,
    String? q128,
  }) : super(
          encodeId: encodeId,
          title: title,
          artistsNames: artistsNames,
          artists: artists,
          thumbnailM: thumbnailM,
          thumbnail: thumbnail,
          link: link,
          duration: duration,
          releaseDate: releaseDate,
          genreIds: genreIds,
          hasLyric: hasLyric,
          q128: q128,
        );

  factory Video.fromJson(Map<String, dynamic> json) {
    List<Artist> tempArtists = [];
    if (json['artists'].isNotEmpty) json['artists'].forEach((artist) => tempArtists.add(Artist.fromJson(artist)));

    return Video(
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
      q128: json['streaming']?['128'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}
