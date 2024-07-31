import 'package:flutter/material.dart';
import 'package:flutter_music_app/common/constants.dart';
import 'package:just_audio/just_audio.dart';

class MinimizeCurrentSong extends StatefulWidget {
  const MinimizeCurrentSong({super.key});

  @override
  State<MinimizeCurrentSong> createState() => _MinimizeCurrentSongState();
}

class _MinimizeCurrentSongState extends State<MinimizeCurrentSong> {
  AudioPlayer audioPlayer = Constants.audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              audioPlayer.sequenceState!.currentSource!.tag.artUri.toString(),
              width: 30,
              height: 30,
              errorBuilder: (context, error, stackTrace) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: const Icon(Icons.music_note, size: 30),
                );
              },
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  audioPlayer.sequenceState!.currentSource!.tag.title,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  audioPlayer.sequenceState!.currentSource!.tag.artist,
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
    );
  }
}

//  {id: Z7998Z9W, title: Thế Giới Của Kẻ Tương Tư, album: No album, artist: Khiem, genre: null, duration: null, artUri: https://photo-resize-zmp3.zmdcdn.me/w94_r1x1_jpeg/cover/8/2/0/8/82085f4e637569e18ad756f1278d6797.jpg, playable: true, displayTitle: null, displaySubtitle: null, displayDescription: null, rating: null, extras: null}      