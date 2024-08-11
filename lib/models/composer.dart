import 'package:flutter_music_app/models/artist.dart';

class Composer extends Artist {
  Composer({
    String? id,
    String? name,
    String? link,
    String? thumbnail,
    int? totalFollow,
  }) : super(
          id: id,
          name: name,
          link: link,
          thumbnail: thumbnail,
          totalFollow: totalFollow,
        );

  factory Composer.fromJson(Map<String, dynamic> json) {
    return Composer(
      id: json['id'],
      name: json['name'],
      link: json['link'],
      thumbnail: json['thumbnail'],
      totalFollow: json['totalFollow'],
    );
  }
}
