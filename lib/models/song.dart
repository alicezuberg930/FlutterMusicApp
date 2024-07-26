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
    this.genreIds,
    this.hasLyric,
    this.q128,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    List<Artist> tempArtists = [];
    if (json['artists'].isNotEmpty) json['artists'].forEach((artist) => tempArtists.add(Artist.fromJson(artist)));
    return Song(
      encodeId: json['encodeId'],
      title: json['title'],
      artistsNames: json['artistsNames'],
      artists: tempArtists,
      thumbnailM: json['thumbnailM'],
      thumbnail: json['thumbnail'],
      link: json['link'],
      duration: json['duration'],
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
      "artists": artists![0].toJson()
    };
  }

  // static List<Song> songs = [
  //   Song(
  //     title: 'LiSA - Gurenge',
  //     description: 'Nhạc việt',
  //     url: 'assets/music/LiSA - Gurenge.mp3',
  //     coverUrl: 'assets/image/Daniel_Park_UI.jpg',
  //   ),
  //   Song(
  //     title: 'H2K x Sli Petey - Phượng Buồn',
  //     description: 'Nhạc việt',
  //     url: 'assets/music/H2K x Sli Petey - Phượng Buồn.mp3',
  //     coverUrl: 'assets/image/Kwak_Jichang.jpg',
  //   ),
  //   Song(
  //     title: 'Shiro Sagisu, Yoko Takahashi - The Cruel Angel"s Thesis',
  //     description: 'Nhạc nhật',
  //     url:
  //         "assets/music/Shiro Sagisu, Yoko Takahashi - The Cruel Angel's Thesis.mp3",
  //     coverUrl: 'assets/image/OG_Daniel_After_Training_Fight.jpg',
  //   ),
  //   Song(
  //     title: 'TK - Unravel',
  //     description: 'Nhạc nhật',
  //     url: 'assets/music/TK - Unravel.mp3',
  //     coverUrl: 'assets/image/Park_Jong_Gun.jpg',
  //   ),
  //   Song(
  //     title: 'Toa - Idsmile (ft. Hatsune Miku, Kagamine Rin)',
  //     description: 'Nhạc nhật',
  //     url: 'assets/music/Toa - Idsmile (ft. Hatsune Miku, Kagamine Rin).mp3',
  //     coverUrl: 'assets/image/Vasco.jpg',
  //   ),
  //   Song(
  //     title: 'WaVe - Ride On',
  //     description: 'Nhạc nhật',
  //     url: 'assets/music/WaVe - Ride On.mp3',
  //     coverUrl: 'assets/image/Young_Jee_Ji_Hoon.jpg',
  //   ),
  // ];
}
