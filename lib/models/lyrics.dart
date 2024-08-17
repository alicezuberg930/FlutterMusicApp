class Lyrics {
  String? file;

  Lyrics({this.file});

  factory Lyrics.fromJson(Map<String, dynamic> json) {
    return Lyrics(file: json['file']);
  }
}
