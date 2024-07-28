import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/widgets/song_card.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LocalAudioScreen extends StatefulWidget {
  const LocalAudioScreen({super.key});

  @override
  State<LocalAudioScreen> createState() => _LocalAudioScreenState();
}

class _LocalAudioScreenState extends State<LocalAudioScreen> {
  OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Text(
              'Local audios',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
            FutureBuilder(
              future: audioQuery.querySongs(
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Colors.purple);
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No songs found on device",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  separatorBuilder: (context, index) => const SizedBox(height: 15),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Song song = Song(
                      encodeId: snapshot.data![index].id.toString(),
                      title: snapshot.data![index].title,
                      artistsNames: snapshot.data![index].artist ?? "<Unknown artist>",
                      q128: snapshot.data![index].uri,
                    );
                    return SongCard(song: song, isOnline: false);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
