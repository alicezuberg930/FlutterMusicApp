// ignore_for_file: must_be_immutable
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_music_app/common/constants.dart';
import 'package:flutter_music_app/common/utils.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/screens/artist_details_screen.dart';
import 'package:flutter_music_app/services/api_service.dart';
import 'package:flutter_music_app/widgets/seekbar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:share_plus/share_plus.dart';

class SongScreen extends StatefulWidget {
  final int index;
  final List<Song> song;
  bool? isOnline;

  SongScreen({Key? key, required this.song, required this.index, this.isOnline}) : super(key: key);

  @override
  State<SongScreen> createState() => _SongPageState();
}

class _SongPageState extends State<SongScreen> {
  int songIndex = 0;
  ApiService apiService = ApiService();
  Stream<SeekBarData> seekBarDataStream = rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
    Constants.audioPlayer.positionStream,
    Constants.audioPlayer.durationStream,
    (Duration position, Duration? duration) {
      return SeekBarData(
        position: position,
        duration: duration ?? Duration.zero,
      );
    },
  );
  late StreamSubscription<SequenceState?> streamSubscription;
  String? currentQ128;

  @override
  void initState() {
    songIndex = widget.index;
    if ((Constants.audioPlayer.audioSource != null && Constants.audioPlayer.currentIndex != songIndex) || Constants.audioPlayer.audioSource == null) {
      initSongs();
    }
    streamSubscription = Constants.audioPlayer.sequenceStateStream.listen((event) {
      if (event != null && event.currentIndex > songIndex) {
        setState(() => songIndex += 1);
        if (widget.isOnline == true) setCurrentAudioSource();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  setCurrentAudioSource() async {
    currentQ128 = await apiService.getStreaming(encodeId: widget.song[songIndex].encodeId!);
    await Constants.audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          for (Song song in widget.song)
            AudioSource.uri(
              Uri.parse(currentQ128 ?? Constants.defaultAudio),
              tag: MediaItem(
                id: song.encodeId!,
                album: "No album",
                title: song.title!,
                artist: song.artistsNames,
                artUri: song.thumbnail != null ? Uri.parse(song.thumbnail!) : null,
              ),
            ),
        ],
      ),
      initialIndex: songIndex,
    );
  }

  initSongs() async {
    await Constants.audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          for (Song song in widget.song)
            AudioSource.uri(
              Uri.parse(song.q128 ?? ""),
              tag: MediaItem(
                id: song.encodeId!,
                album: "No album",
                title: song.title!,
                artist: song.artistsNames,
                artUri: song.thumbnail != null ? Uri.parse(song.thumbnail!) : null,
              ),
            ),
        ],
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
                onchangeEnd: Constants.audioPlayer.seek,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [playerButton(Constants.audioPlayer)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArtistDetailsScreen(),
                    ),
                  );
                },
                iconSize: 30,
                color: Colors.white,
                icon: const Icon(Icons.thumb_up),
              ),
              IconButton(
                onPressed: () async {
                  await Share.share("https://zingmp3.vn${song.link}", subject: "Look at this song");
                },
                iconSize: 30,
                color: Colors.white,
                icon: const Icon(Icons.share),
              ),
              if (widget.isOnline == true) ...[
                IconButton(
                  onPressed: () async {
                    await Utils.downloadFile(song.q128!, "${song.artistsNames} - ${song.title!}.mp3");
                  },
                  iconSize: 30,
                  color: Colors.white,
                  icon: const Icon(Icons.download),
                )
              ]
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
                if (audioPlayer.hasPrevious) {
                  audioPlayer.seekToPrevious();
                  setState(() => songIndex -= 1);
                  if (widget.isOnline == true) setCurrentAudioSource();
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
                if (audioPlayer.hasNext) {
                  audioPlayer.seekToNext();
                  setState(() => songIndex += 1);
                  if (widget.isOnline == true) setCurrentAudioSource();
                }
              },
              icon: const Icon(Icons.skip_next),
            );
          },
        ),
      ],
    );
  }
}
