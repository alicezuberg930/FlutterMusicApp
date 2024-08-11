import 'package:flutter_music_app/models/artist.dart';
import 'package:flutter_music_app/models/composer.dart';
import 'package:flutter_music_app/models/genre.dart';
import 'package:flutter_music_app/models/song.dart';

class Video extends Song {
  List<Video> recommends = [];
  dynamic streaming;
  Artist? artist;
  int? like;
  String? lyrics;
  List<Genre> genres = [];
  Song? song;
  List<Composer> composers = [];

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
    required this.genres,
    this.song,
    required this.composers,
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
    List<Genre> tempGenres = [];
    List<Composer> tempComposers = [];
    if (json['artists'].isNotEmpty) json['artists'].forEach((artist) => tempArtists.add(Artist.fromJson(artist)));
    if (json['recommends'] != null && json['recommends'].isNotEmpty) json['recommends'].forEach((recommend) => tempVideos.add(Video.fromJson(recommend)));
    if (json['genres'] != null && json['genres'].isNotEmpty) json['genres'].forEach((genre) => tempGenres.add(Genre.fromJson(genre)));
    if (json['composers'] != null && json['composers'].isNotEmpty) json['composers'].forEach((composer) => tempComposers.add(Composer.fromJson(composer)));

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
      lyrics: json['lyrics'] != null ? json['lyrics'][0]['content'] : "No lyrics found",
      genres: tempGenres,
      song: json['song'] != null ? Song.fromJson(json['song']) : null,
      composers: tempComposers,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }

  String get composerNames => getComposerNames();
  String get genreNames => getGenreNames();

  String getComposerNames() {
    String composerNames = "";
    for (int i = 0; i < composers.length; i++) {
      composerNames += composers[i].name!;
      if (i < composers.length - 1) composerNames += ", ";
    }
    return composerNames;
  }

  String getGenreNames() {
    String genreNames = "";
    for (int i = 0; i < genres.length; i++) {
      genreNames += genres[i].name!;
      if (i < genres.length - 1) genreNames += ", ";
    }
    return genreNames;
  }
}
