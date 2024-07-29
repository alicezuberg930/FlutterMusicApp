class Artist {
  String? id;
  String? name;
  String? link;
  String? thumbnail;
  String? thumbnailM;
  int? totalFollow;

  Artist({this.id, this.name, this.link, this.thumbnail, this.thumbnailM, this.totalFollow});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      link: json['link'],
      thumbnail: json['thumbnail'],
      thumbnailM: json['thumbnailM'],
      totalFollow: json['totalFollow'],
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
    };
  }
}
