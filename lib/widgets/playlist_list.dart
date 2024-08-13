import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/widgets/playlist_card.dart';

class PlaylistList extends StatelessWidget {
  final List<Playlist> playlists;
  const PlaylistList({super.key, required this.playlists});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 211,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemCount: playlists.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return PlaylistCard(playlist: playlists[index]);
        },
      ),
    );
  }
}
