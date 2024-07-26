import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/widgets/song_card.dart';

class NewReleaseScreen extends StatefulWidget {
  final List<Song> songs;
  const NewReleaseScreen({super.key, required this.songs});

  @override
  State<NewReleaseScreen> createState() => _NewReleaseScreenState();
}

class _NewReleaseScreenState extends State<NewReleaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200.withOpacity(0.8),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("New release"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            shrinkWrap: true,
            itemCount: widget.songs.length,
            itemBuilder: (context, index) {
              return SongCard(song: widget.songs[index], isOnline: true);
            },
          ),
        ),
      ),
    );
  }
}
