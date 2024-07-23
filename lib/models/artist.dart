class Artist {
  String? id;
  String? name;
  String? link;
  String? thumbnailM;

  Artist({this.id, this.name, this.link, this.thumbnailM});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      link: json['link'],
      thumbnailM: json['thumbnailM'],
    );
  }

  toJson() {
    return {
      "id": id,
      "name": name,
      "link": link,
      "thumbnailM": thumbnailM,
    };
  }
}
