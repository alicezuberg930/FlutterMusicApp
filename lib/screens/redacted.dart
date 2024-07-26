import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/screens/song_screen.dart';
import 'package:just_audio/just_audio.dart';

class PlaylistScreen extends StatefulWidget {
  final Playlist playlist;
  const PlaylistScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistScreen> {
  bool isPlay = true;
  int index = 0;
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        shuffleOrder: DefaultShuffleOrder(),
        children: [
          for (int i = 0; i < widget.playlist.songs.length; i++)
            AudioSource.uri(
              Uri.parse('asset:///${widget.playlist.songs[i].title}'),
            )
        ],
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: audioPlayer.hasNext
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.purple.shade500.withOpacity(0.5),
                    Colors.purple.shade400.withOpacity(0.5),
                    Colors.purple.shade300.withOpacity(0.5),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 15),
                  StreamBuilder(
                    stream: audioPlayer.playerStateStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final playerState = snapshot.data;
                        final processingState = (playerState!).processingState;
                        if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                          return Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.all(10),
                            child: const CircularProgressIndicator(),
                          );
                        } else if (!audioPlayer.playing) {
                          return IconButton(
                            onPressed: () {
                              audioPlayer.play();
                            },
                            iconSize: 30,
                            icon: const Icon(Icons.play_circle, color: Colors.white),
                          );
                        } else {
                          return IconButton(
                            onPressed: () {
                              audioPlayer.pause();
                            },
                            iconSize: 30,
                            icon: const Icon(Icons.pause_circle, color: Colors.white),
                          );
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      widget.playlist.songs[audioPlayer.currentIndex!].title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
      body: Container(
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
            title: const Text("Danh sách phát của bạn"),
          ),
          body: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.playlist.thumbnailM!,
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    widget.playlist.title!,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 200),
                          left: isPlay ? 0 : MediaQuery.of(context).size.width * 0.45,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade400,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isPlay = true;
                                  });
                                  audioPlayer.play();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        "Phát",
                                        style: TextStyle(
                                          color: isPlay ? Colors.white : Colors.deepPurple,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.play_circle,
                                      color: isPlay ? Colors.white : Colors.deepPurple,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  audioPlayer.play();
                                  setState(() {
                                    isPlay = false;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        "Xáo trộn",
                                        style: TextStyle(
                                          color: isPlay ? Colors.deepPurple : Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.shuffle,
                                      color: isPlay ? Colors.deepPurple : Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.only(top: 15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.playlist.songs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepPurple.shade400,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SongScreen(
                                  song: widget.playlist.songs,
                                  index: index,
                                ),
                              ),
                            );
                          },
                          leading: Text(
                            '${index + 1}',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          title: Text(
                            widget.playlist.songs[index].title!,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(widget.playlist.songs[index].artistsNames!, style: Theme.of(context).textTheme.bodySmall!),
                          trailing: const Icon(Icons.more_vert, color: Colors.white),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
