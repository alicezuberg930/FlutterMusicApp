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
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: Image.network(song.thumbnailM!).image,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.35,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
