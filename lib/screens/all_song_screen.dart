import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/widgets/song_card.dart';

class AllSongScreen extends StatefulWidget {
  final List<Song> songs;
  const AllSongScreen({super.key, required this.songs});

  @override
  State<AllSongScreen> createState() => _AllSongScreenState();
}

class _AllSongScreenState extends State<AllSongScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("New release", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          shrinkWrap: true,
          itemCount: widget.songs.length,
          itemBuilder: (context, index) {
            return SongCard(isOnline: true, index: index, songs: widget.songs);
          },
        ),
      ),
    );
  }
}
