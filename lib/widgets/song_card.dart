// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/screens/song_screen.dart';

class SongCard extends StatelessWidget {
  bool? isOnline;
  final Song song;
  SongCard({super.key, required this.song, this.isOnline});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongScreen(song: [song], index: 0, isOnline: isOnline),
          ),
        );
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: Image.network(song.thumbnail!).image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  song.artistsNames!,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          InkWell(
            child: const Icon(Icons.more_vert),
            onTap: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        leading: const Icon(Icons.download, color: Colors.black),
                        title: const Text("Download", style: TextStyle(color: Colors.black)),
                      )
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
