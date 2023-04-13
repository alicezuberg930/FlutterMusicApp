class Song {
  final String title;
  final String description;
  final String url;
  final String coverUrl;
  Song({
    required this.title,
    required this.description,
    required this.url,
    required this.coverUrl,
  });
  static List<Song> songs = [
    Song(
      title: 'LiSA - Gurenge',
      description: 'Nhạc việt',
      url: 'assets/music/LiSA - Gurenge.mp3',
      coverUrl: 'assets/image/Daniel_Park_UI.jpg',
    ),
    Song(
      title: 'H2K x Sli Petey - Phượng Buồn',
      description: 'Nhạc việt',
      url: 'assets/music/H2K x Sli Petey - Phượng Buồn.mp3',
      coverUrl: 'assets/image/Kwak_Jichang.jpg',
    ),
    Song(
      title: 'Shiro Sagisu, Yoko Takahashi - The Cruel Angel"s Thesis',
      description: 'Nhạc nhật',
      url:
          'assets/music/Shiro Sagisu, Yoko Takahashi- The Cruel Angel\'s Thesis.mp3',
      coverUrl: 'assets/image/OG_Daniel_After_Training_Fight.jpg',
    ),
    Song(
      title: 'TK - Unravel',
      description: 'Nhạc nhật',
      url: 'assets/music/TK - Unravel.mp3',
      coverUrl: 'assets/image/Park_Jong_Gun.jpg',
    ),
    Song(
      title: 'Toa - Idsmile (ft. Hatsune Miku, Kagamine Rin)',
      description: 'Nhạc nhật',
      url: 'assets/music/Toa - Idsmile (ft. Hatsune Miku, Kagamine Rin).mp3',
      coverUrl: 'assets/image/Vasco.jpg',
    ),
    Song(
      title: 'WaVe - Ride On',
      description: 'Nhạc nhật',
      url: 'assets/music/WaVe - Ride On.mp3',
      coverUrl: 'assets/image/Young_Jee_Ji_Hoon.jpg',
    ),
  ];
}
