import 'package:flutter_music_app/models/artist.dart';
import 'package:flutter_music_app/models/song.dart';

class Video extends Song {
  List<Video> recommends = [];
  dynamic streaming;
  Artist? artist;
  int? like;
  String? lyrics;

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
    required this.recommends,
    this.streaming,
    this.artist,
    this.like,
    this.lyrics,
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
    List<Video> tempVideos = [];
    if (json['artists'].isNotEmpty) json['artists'].forEach((artist) => tempArtists.add(Artist.fromJson(artist)));
    if (json['recommends'] != null && json['recommends'].isNotEmpty) {
      json['recommends'].forEach((recommend) => tempVideos.add(Video.fromJson(recommend)));
    }

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
      recommends: tempVideos,
      streaming: json['streaming']?['mp4'],
      artist: Artist.fromJson(json['artist']),
      like: json['like'],
      lyrics: json['lyrics'] != null ? json['lyrics'][0]['content'] : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}
