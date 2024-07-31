import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/services/api_service.dart';
import 'package:flutter_music_app/widgets/seekbar.dart';
import 'package:flutter_music_app/widgets/song_card.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class PlayListDetailsScreen extends StatefulWidget {
  final String encodeId;
  const PlayListDetailsScreen({super.key, required this.encodeId});

  @override
  State<PlayListDetailsScreen> createState() => _PlayListDetailsScreenState();
}

class _PlayListDetailsScreenState extends State<PlayListDetailsScreen> {
  ApiService apiService = ApiService();
  Playlist? playlist;
  String? totalTime;
  AudioPlayer audioPlayer = AudioPlayer();
  Stream<SeekBarData> get seekBarDataStream => rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
        audioPlayer.positionStream,
        audioPlayer.durationStream,
        (Duration position, Duration? duration) {
          return SeekBarData(
            position: position,
            duration: duration ?? Duration.zero,
          );
        },
      );

  @override
  void initState() {
    getPlaylist();
    super.initState();
  }

  getPlaylist() async {
    Playlist? temp = await apiService.getPlaylist(encodeId: widget.encodeId);
    int seconds = 0;
    for (Song song in temp!.songs) {
      seconds += song.duration!;
    }
    totalTime = "${(seconds / 3600).floor()} hours ${(seconds % 60).floor()} minutes";
    setState(() => playlist = temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: playlist == null
            ? const Center(child: CircularProgressIndicator(color: Colors.purple))
            : playlist!.songs.isEmpty
                ? const Center(child: Text("No songs found"))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back),
                              ),
                              IconButton(
                                onPressed: () {
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
                                            leading: const Icon(Icons.search, color: Colors.black),
                                            title: const Text("Search songs/artists", style: TextStyle(color: Colors.black)),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.more_vert),
                              )
                            ],
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              playlist!.thumbnailM!,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            playlist!.title!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${playlist!.songs.length} songs * $totalTime",
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.black.withOpacity(0.5)),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: const Icon(Icons.download_sharp),
                                  ),
                                  const Text("Download", style: TextStyle(color: Colors.black, fontSize: 12)),
                                ],
                              ),
                              const SizedBox(width: 15),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 25),
                                  backgroundColor: Colors.deepPurple.shade800,
                                ),
                                onPressed: () {},
                                child: const Text(
                                  "PLAY RANDOM",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: const Icon(CupertinoIcons.heart),
                                  ),
                                  const Text("Favorite", style: TextStyle(color: Colors.black, fontSize: 12)),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            playlist!.sortDescription!,
                            style: const TextStyle(color: Colors.black),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 20),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) => const SizedBox(height: 15),
                            shrinkWrap: true,
                            itemCount: playlist!.songs.length,
                            itemBuilder: (context, index) {
                              return SongCard(isOnline: true, index: index, songs: playlist!.songs);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
