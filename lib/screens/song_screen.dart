// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_music_app/common/constants.dart';
import 'package:flutter_music_app/common/utils.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/screens/artist_details_screen.dart';
import 'package:flutter_music_app/services/api_service.dart';
import 'package:flutter_music_app/services/route_generator_service.dart';
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

class _SongPageState extends State<SongScreen> with SingleTickerProviderStateMixin {
  int songIndex = 0;
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
  bool isLoop = false;
  late AnimationController animationController;
  Uint8List? offlineImg;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..addListener(() => setState(() {}));
    if (Constants.audioPlayer.playing) animationController.repeat();
    songIndex = widget.index;
    if ((Constants.audioPlayer.audioSource != null && Constants.audioPlayer.currentIndex != songIndex) || Constants.audioPlayer.audioSource == null) {
      initSongs();
    }
    if (widget.isOnline == false) getOfflineImage();
    streamSubscription = Constants.audioPlayer.sequenceStateStream.listen((event) {
      if (event != null && event.currentIndex > songIndex) {
        setState(() => songIndex += 1);
        if (widget.isOnline == true) setCurrentAudioSource();
        if (widget.isOnline == false) getOfflineImage();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  getOfflineImage() async {
    Uint8List? temp = await OnAudioQuery().queryArtwork(
      int.parse(widget.song[songIndex].encodeId!),
      ArtworkType.AUDIO,
      quality: 100,
      format: ArtworkFormat.JPEG,
    );
    setState(() => offlineImg = temp);
  }

  setCurrentAudioSource() async {
    currentQ128 = await ApiService.getStreaming(encodeId: widget.song[songIndex].encodeId!);
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
        alignment: Alignment.topCenter,
        children: [
          backgroundFilter(),
          musicBackgroundWidget(),
          exitButtonWidget(),
          musicPlayerWidget(),
        ],
      ),
    );
  }

  backgroundFilter() {
    return ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF000000),
            Color(0xFF4C0053),
            Color(0xFFB471AE),
          ],
          stops: [0.0, 0.5, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.srcATop,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  musicBackgroundWidget() {
    return Positioned(
      top: MediaQuery.of(context).size.width * 0.3,
      child: RotationTransition(
        turns: animationController,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: widget.isOnline == true
              ? Image.network(
                  widget.song[songIndex].thumbnailM!,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  height: MediaQuery.of(context).size.width * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                )
              : offlineImg != null
                  ? Image.memory(
                      offlineImg!,
                      scale: 2,
                      height: MediaQuery.of(context).size.width * 0.8,
                      width: MediaQuery.of(context).size.width * 0.8,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                        height: MediaQuery.of(context).size.width * 0.8,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Image.asset(
                          "assets/image/music_note.png",
                          color: Colors.purpleAccent,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  musicPlayerWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.song[songIndex].title!,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            widget.song[songIndex].artistsNames!,
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
            children: [playerButtonWidget(Constants.audioPlayer)],
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
                onPressed: () async {
                  await Share.share("${Constants.apiUrl}${widget.song[songIndex].link}", subject: "Look at this song");
                },
                iconSize: 30,
                color: Colors.white,
                icon: const Icon(Icons.share),
              ),
              if (widget.isOnline == true) ...[
                IconButton(
                  onPressed: () async {
                    await Utils.downloadFile(
                      widget.song[songIndex].q128!,
                      "${widget.song[songIndex].artistsNames} - ${widget.song[songIndex].title!}.mp3",
                    );
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

  exitButtonWidget() {
    return Positioned(
      top: 0,
      left: 0,
      child: IconButton(
        iconSize: 35,
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
      ),
    );
  }

  playerButtonWidget(AudioPlayer audioPlayer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 30,
          color: isLoop ? Colors.purple[600] : Colors.grey,
          onPressed: () {},
          icon: const Icon(Icons.shuffle),
        ),
        StreamBuilder(
          stream: audioPlayer.sequenceStateStream,
          builder: (context, snapshot) {
            return IconButton(
              iconSize: 60,
              color: audioPlayer.hasPrevious ? Colors.white : Colors.grey[600],
              onPressed: () {
                if (audioPlayer.hasPrevious) {
                  audioPlayer.seekToPrevious();
                  setState(() => songIndex -= 1);
                  if (widget.isOnline == true) setCurrentAudioSource();
                  if (widget.isOnline == false) getOfflineImage();
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
                    animationController.repeat();
                    audioPlayer.play();
                  },
                  iconSize: 60,
                  icon: const Icon(Icons.play_circle, color: Colors.white),
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  onPressed: () {
                    animationController.stop();
                    audioPlayer.pause();
                  },
                  iconSize: 60,
                  icon: const Icon(Icons.pause_circle, color: Colors.white),
                );
              } else {
                return IconButton(
                  onPressed: () {
                    audioPlayer.seek(Duration.zero, index: audioPlayer.effectiveIndices!.first);
                  },
                  iconSize: 60,
                  icon: const Icon(Icons.replay_circle_filled_outlined, color: Colors.white),
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
              color: audioPlayer.hasNext ? Colors.white : Colors.grey[600],
              onPressed: () {
                if (audioPlayer.hasNext) {
                  audioPlayer.seekToNext();
                  setState(() => songIndex += 1);
                  if (widget.isOnline == true) setCurrentAudioSource();
                  if (widget.isOnline == false) getOfflineImage();
                }
              },
              icon: const Icon(Icons.skip_next),
            );
          },
        ),
        IconButton(
          iconSize: 30,
          color: isLoop ? Colors.purple[600] : Colors.grey,
          onPressed: () {
            if (isLoop) {
              audioPlayer.setLoopMode(LoopMode.off);
            } else {
              audioPlayer.setLoopMode(LoopMode.one);
            }
            setState(() => isLoop = !isLoop);
          },
          icon: const Icon(Icons.replay),
        ),
      ],
    );
  }
}
