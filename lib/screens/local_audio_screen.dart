import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/widgets/song_card.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalAudioScreen extends StatefulWidget {
  const LocalAudioScreen({super.key});

  @override
  State<LocalAudioScreen> createState() => _LocalAudioScreenState();
}

class _LocalAudioScreenState extends State<LocalAudioScreen> {
  OnAudioQuery audioQuery = OnAudioQuery();
  bool isAudioAllowed = false;

  @override
  void initState() {
    handlePermission();
    super.initState();
  }

  handlePermission() async {
    PermissionStatus storagePermission = await Permission.manageExternalStorage.request();
    if (storagePermission.isGranted) {
      setState(() => isAudioAllowed = true);
    } else {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: isAudioAllowed
            ? FutureBuilder(
                future: audioQuery.querySongs(
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Colors.purple);
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data != null && snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "No songs found on device",
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                  }
                  List<Song> tempSongs = [];
                  for (var element in snapshot.data!) {
                    tempSongs.add(Song(
                      encodeId: element.id.toString(),
                      title: element.title,
                      artistsNames: element.artist ?? "<Unknown artist>",
                      q128: element.uri,
                    ));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    separatorBuilder: (context, index) => const SizedBox(height: 15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tempSongs.length,
                    itemBuilder: (context, index) {
                      return SongCard(isOnline: false, songs: tempSongs, index: index);
                    },
                  );
                },
              )
            : Center(
                child: Text(
                  'Please give app permission to read audio file',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                ),
              ),
      ),
    );
  }
}
