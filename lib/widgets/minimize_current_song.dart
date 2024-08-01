import 'package:flutter/material.dart';
import 'package:flutter_music_app/common/constants.dart';
import 'package:just_audio/just_audio.dart';

class MinimizeCurrentSong extends StatefulWidget {
  const MinimizeCurrentSong({super.key});

  @override
  State<MinimizeCurrentSong> createState() => _MinimizeCurrentSongState();
}

class _MinimizeCurrentSongState extends State<MinimizeCurrentSong> with TickerProviderStateMixin {
  AudioPlayer audioPlayer = Constants.audioPlayer;
  String? artUri, title, artist;
  int? index;
  AnimationController? animationController;

  @override
  void initState() {
    updateSongUI();
    index = audioPlayer.sequenceState!.currentIndex;
    audioPlayer.sequenceStateStream.listen((event) {
      if (event != null && event.currentIndex > index!) {
        updateSongUI();
        index = index! + 1;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(
          value: animationController?.value,
          backgroundColor: Colors.purple[50],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[600]!),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  artUri ?? "",
                  width: 45,
                  height: 45,
                  errorBuilder: (context, error, stackTrace) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: const Icon(Icons.music_note, size: 30),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title ?? "",
                      maxLines: 1,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      artist ?? "",
                      maxLines: 1,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder(
                    stream: audioPlayer.sequenceStateStream,
                    builder: (context, snapshot) {
                      return IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 30,
                        color: audioPlayer.hasPrevious ? Colors.blue.shade400 : Colors.grey,
                        onPressed: () {
                          if (audioPlayer.hasPrevious) {
                            audioPlayer.seekToPrevious();
                            updateSongUI();
                          }
                        },
                        icon: const Icon(Icons.skip_previous),
                      );
                    },
                  ),
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
                            padding: EdgeInsets.zero,
                            iconSize: 30,
                            icon: Icon(Icons.play_circle, color: Colors.blue.shade400),
                          );
                        } else if (processingState != ProcessingState.completed) {
                          return IconButton(
                            onPressed: () {
                              audioPlayer.pause();
                            },
                            padding: EdgeInsets.zero,
                            iconSize: 30,
                            icon: Icon(Icons.pause_circle, color: Colors.blue.shade400),
                          );
                        } else {
                          return IconButton(
                            onPressed: () {
                              audioPlayer.seek(Duration.zero, index: audioPlayer.effectiveIndices!.first);
                            },
                            padding: EdgeInsets.zero,
                            iconSize: 30,
                            icon: Icon(Icons.replay_circle_filled_outlined, color: Colors.blue.shade300),
                          );
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  StreamBuilder(
                    stream: audioPlayer.sequenceStateStream,
                    builder: (context, snapshot) {
                      return IconButton(
                        iconSize: 30,
                        color: audioPlayer.hasNext ? Colors.blue.shade400 : Colors.grey,
                        onPressed: () {
                          if (audioPlayer.hasNext) {
                            audioPlayer.seekToNext();
                            updateSongUI();
                          }
                        },
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.skip_next),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  updateSongUI() async {
    setState(() {
      artUri = audioPlayer.sequenceState!.currentSource!.tag.artUri.toString();
      title = audioPlayer.sequenceState!.currentSource!.tag.title;
      artist = audioPlayer.sequenceState!.currentSource!.tag.artist;
    });
    await Future.delayed(const Duration(seconds: 1));
    animationController = AnimationController(vsync: this, duration: audioPlayer.duration)
      ..addListener(() {
        setState(() {});
      });
    animationController!.repeat();
  }
}
