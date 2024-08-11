class Genre {
  String? id;
  String? name;
  String? title;
  String? alias;
  String? link;

  Genre({this.id, this.name, this.title, this.alias, this.link});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      alias: json['alias'],
      link: json['link'],
    );
  }
}
