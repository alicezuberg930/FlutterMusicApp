// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_music_app/common/ui_helpers.dart';
import 'package:flutter_music_app/common/utils.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/services/api_service.dart';
import 'package:flutter_music_app/widgets/seekbar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class SongScreen extends StatefulWidget {
  final int index;
  final List<Song> song;
  bool? isOnline;
  AudioSource? audioSource;
  SongScreen({Key? key, required this.song, required this.index, this.isOnline, this.audioSource}) : super(key: key);

  @override
  State<SongScreen> createState() => _SongPageState();
}

class _SongPageState extends State<SongScreen> {
  int songIndex = 0;
  AudioPlayer audioPlayer = AudioPlayer();
  ApiService apiService = ApiService();
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
    initSong();
    // songIndex = widget.index;
    // audioPlayer.setAudioSource(
    //   ConcatenatingAudioSource(
    //     children: [
    //       for (int i = 0; i < widget.song.length; i++)
    //         AudioSource.uri(
    //           Uri.parse('asset:///${widget.song[i].title}'),
    //         )
    //     ],
    //   ),
    //   initialIndex: songIndex,
    // );
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  initSong() async {
    Song? song;
    if (widget.song[0].q128 == null) {
      song = await apiService.getInfo(encodeId: widget.song[0].encodeId!);
      if (song == null && context.mounted) {
        UIHelpers.showSnackBar(context, Colors.red, "Bài hát chỉ dành cho tài khoản VIP");
        return;
      }
    } else {
      song = widget.song[0];
    }
    audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(song!.q128!),
        tag: MediaItem(
          id: song.encodeId!,
          album: "No album",
          title: song.title!,
          artist: song.artistsNames,
          artUri: song.thumbnail != null ? Uri.parse(song.thumbnail!) : null,
        ),
      ),
      initialIndex: songIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.isOnline == true
              ? Image.network(widget.song[songIndex].thumbnailM!, fit: BoxFit.cover)
              : QueryArtworkWidget(
                  artworkHeight: MediaQuery.of(context).size.height,
                  artworkWidth: MediaQuery.of(context).size.width,
                  artworkFit: BoxFit.cover,
                  artworkBorder: BorderRadius.circular(10),
                  id: int.parse(widget.song[songIndex].encodeId!),
                  type: ArtworkType.AUDIO,
                  quality: 100,
                  artworkQuality: FilterQuality.high,
                ),
          backgroundFilter(),
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              iconSize: 35,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            ),
          ),
          musicPlayerWidget(widget.song[songIndex]),
        ],
      ),
    );
  }

  backgroundFilter() {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.0),
          ],
          stops: const [0.2, 0.4, 0.7],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade800,
            ],
          ),
        ),
      ),
    );
  }

  musicPlayerWidget(Song song) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            song.title!,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            song.artistsNames!,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 30),
          StreamBuilder<SeekBarData>(
            stream: seekBarDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                position: positionData?.position ?? Duration.zero,
                duration: positionData?.duration ?? Duration.zero,
                onchangeEnd: audioPlayer.seek,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [playerButton(audioPlayer)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                iconSize: 30,
                color: Colors.white,
                icon: const Icon(Icons.thumb_up),
              ),
              IconButton(
                onPressed: () {},
                iconSize: 30,
                color: Colors.white,
                icon: const Icon(Icons.share),
              ),
              if (widget.isOnline == true) ...[
                IconButton(
                  onPressed: () async {
                    if (song.q128 != null) await Utils.downloadFile(song.q128!, "${song.artistsNames} - ${song.title!}.mp3");
                  },
                  iconSize: 30,
                  color: Colors.white,
                  icon: const Icon(Icons.download),
                )
              ]
              // IconButton(
              //   onPressed: () {},
              //   iconSize: 30,
              //   color: Colors.white,
              //   icon: const Icon(Icons.settings),
              // )
            ],
          )
        ],
      ),
    );
  }

  playerButton(AudioPlayer audioPlayer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
          stream: audioPlayer.sequenceStateStream,
          builder: (context, snapshot) {
            return IconButton(
              iconSize: 60,
              color: audioPlayer.hasPrevious ? Colors.blue.shade400 : Colors.grey,
              onPressed: () {
                if (audioPlayer.hasPrevious) audioPlayer.seekToPrevious();
                if (songIndex > 0) setState(() => songIndex -= 1);
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
                  width: 64,
                  height: 64,
                  margin: const EdgeInsets.all(10),
                  child: const CircularProgressIndicator(),
                );
              } else if (!audioPlayer.playing) {
                return IconButton(
                  onPressed: () {
                    audioPlayer.play();
                  },
                  iconSize: 60,
                  icon: Icon(Icons.play_circle, color: Colors.blue.shade400),
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  onPressed: () {
                    audioPlayer.pause();
                  },
                  iconSize: 60,
                  icon: Icon(Icons.pause_circle, color: Colors.blue.shade400),
                );
              } else {
                return IconButton(
                  onPressed: () {
                    audioPlayer.seek(Duration.zero, index: audioPlayer.effectiveIndices!.first);
                  },
                  iconSize: 60,
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
              iconSize: 60,
              color: audioPlayer.hasNext ? Colors.blue.shade400 : Colors.grey,
              onPressed: () {
                if (audioPlayer.hasNext) audioPlayer.seekToNext();
                if (songIndex < widget.song.length - 1) setState(() => songIndex += 1);
              },
              icon: const Icon(Icons.skip_next),
            );
          },
        ),
      ],
    );
  }
}
