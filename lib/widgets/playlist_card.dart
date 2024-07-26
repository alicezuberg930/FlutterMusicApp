import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/screens/redacted.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playList;
  const PlaylistCard({super.key, required this.playList});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlaylistScreen(playlist: playList)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: Colors.deepPurple.shade800.withOpacity(0.8), borderRadius: BorderRadius.circular(15)),
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                playList.thumbnailM!,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playList.title!,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${playList.songs.length} songs',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.play_circle, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
