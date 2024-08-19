import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_music_app/common/constants.dart';
import 'package:flutter_music_app/common/shared_preference.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/services/api_service.dart';
import 'package:flutter_music_app/widgets/seekbar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class MinimizeCurrentSong extends StatefulWidget {
  const MinimizeCurrentSong({super.key});

  @override
  State<MinimizeCurrentSong> createState() => _MinimizeCurrentSongState();
}

class _MinimizeCurrentSongState extends State<MinimizeCurrentSong> with TickerProviderStateMixin {
  AudioPlayer audioPlayer = Constants.audioPlayer;
  double? dragValue;
  Stream<SeekBarData>? seekBarDataStream = rxdart.Rx.combineLatest2<Duration?, Duration?, SeekBarData>(
    Constants.audioPlayer.positionStream,
    Constants.audioPlayer.durationStream,
    (Duration? position, Duration? duration) {
      return SeekBarData(
        position: position ?? Duration.zero,
        duration: duration ?? Duration.zero,
      );
    },
  );
  StreamSubscription? streamSubscription;
  int? songIndex;

  @override
  void initState() {
    songIndex = audioPlayer.currentIndex ?? 0;
    streamSubscription = audioPlayer.sequenceStateStream.listen((event) {
      if (event != null && event.currentIndex != songIndex) {
        // setCurrentAudioSource(event.currentIndex);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  setCurrentAudioSource(int index) async {
    // List<Song> playlist = SharedPreference.getCurrentPlaylist();
    // String? currentQ128 = await ApiService.getStreaming(encodeId: playlist[index].encodeId!);
    // await audioPlayer.setAudioSource(
    //   ConcatenatingAudioSource(
    //     children: [
    //       for (Song song in playlist)
    //         AudioSource.uri(
    //           Uri.parse(currentQ128 ?? Constants.defaultAudio),
    //           tag: MediaItem(
    //             id: song.encodeId!,
    //             album: "No album",
    //             title: song.title!,
    //             artist: song.artistsNames,
    //             artUri: song.thumbnail != null ? Uri.parse(song.thumbnail!) : null,
    //           ),
    //         ),
    //     ],
    //   ),
    //   initialIndex: index,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audioPlayer.sequenceStateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<SeekBarData>(
                stream: seekBarDataStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(disabledThumbRadius: 5, enabledThumbRadius: 5),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                        activeTrackColor: Colors.purple,
                        inactiveTrackColor: Colors.grey.withOpacity(0.8),
                        thumbColor: Colors.white,
                        overlayColor: Colors.white,
                      ),
                      child: Slider(
                        min: 0.0,
                        max: snapshot.data!.duration.inMilliseconds.toDouble(),
                        value: min(
                          dragValue ?? snapshot.data!.position.inMilliseconds.toDouble(),
                          snapshot.data!.duration.inMilliseconds.toDouble(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            dragValue = value;
                          });
                          audioPlayer.seek(Duration(milliseconds: value.toInt()));
                        },
                        onChangeEnd: (value) {
                          audioPlayer.seek(Duration(milliseconds: value.toInt()));
                          setState(() {
                            dragValue = null;
                          });
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        snapshot.data!.currentSource!.tag.artUri.toString(),
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
                            snapshot.data!.currentSource!.tag.title ?? "",
                            maxLines: 1,
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            snapshot.data!.currentSource!.tag.artist ?? "",
                            maxLines: 1,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 30,
                          color: audioPlayer.hasPrevious ? Colors.blue.shade400 : Colors.grey,
                          onPressed: () {
                            if (audioPlayer.hasPrevious) {
                              audioPlayer.seekToPrevious();
                              setCurrentAudioSource(snapshot.data!.currentIndex);
                            }
                          },
                          icon: const Icon(Icons.skip_previous),
                        ),
                        StreamBuilder(
                          stream: audioPlayer.playerStateStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final processingState = (snapshot.data!).processingState;
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
                        IconButton(
                          iconSize: 30,
                          color: audioPlayer.hasNext ? Colors.blue.shade400 : Colors.grey,
                          onPressed: () {
                            if (audioPlayer.hasNext) {
                              audioPlayer.seekToNext();
                              setCurrentAudioSource(snapshot.data!.currentIndex);
                            }
                          },
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.skip_next),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
