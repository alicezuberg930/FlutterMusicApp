import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import '../widgets/seekbar.dart';

class SongPage extends StatefulWidget {
  final int index;
  final List<Song> song;
  const SongPage({Key? key, required this.song, required this.index})
      : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  int songIndex = 0;
  AudioPlayer audioPlayer = AudioPlayer();
  Stream<SeekBarData> get seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
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
    songIndex = widget.index;
    audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          for (int i = 0; i < widget.song.length; i++)
            AudioSource.uri(
              Uri.parse('asset:///${widget.song[i].url}'),
            )
        ],
      ),
      initialIndex: songIndex,
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            widget.song[songIndex].coverUrl,
            fit: BoxFit.cover,
          ),
          backgroundFilter(),
          musicPlayerWidget(widget.song[songIndex]),
        ],
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
            song.title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            song.description,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                ),
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
            children: [
              playerButton(audioPlayer),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                iconSize: 30,
                color: Colors.white,
                icon: const Icon(Icons.heart_broken),
              ),
              IconButton(
                onPressed: () {},
                iconSize: 30,
                color: Colors.white,
                icon: const Icon(Icons.comment),
              ),
              IconButton(
                onPressed: () {},
                iconSize: 30,
                color: Colors.white,
                icon: const Icon(Icons.share),
              ),
              IconButton(
                onPressed: () {},
                iconSize: 30,
                color: Colors.white,
                icon: const Icon(Icons.download),
              ),
              IconButton(
                onPressed: () {},
                iconSize: 30,
                color: Colors.white,
                icon: const Icon(Icons.settings),
              )
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
              color:
                  audioPlayer.hasPrevious ? Colors.blue.shade400 : Colors.grey,
              onPressed: () {
                if (audioPlayer.hasPrevious) {
                  audioPlayer.seekToPrevious();
                }
                if (songIndex > 0) {
                  setState(() {
                    songIndex -= 1;
                  });
                }
              },
              icon: const Icon(
                Icons.skip_previous,
              ),
            );
          },
        ),
        StreamBuilder(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final playerState = snapshot.data;
              final processingState =
                  (playerState! as PlayerState).processingState;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
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
                  icon: Icon(
                    Icons.play_circle,
                    color: Colors.blue.shade400,
                  ),
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  onPressed: () {
                    audioPlayer.pause();
                  },
                  iconSize: 60,
                  icon: Icon(
                    Icons.pause_circle,
                    color: Colors.blue.shade400,
                  ),
                );
              } else {
                return IconButton(
                  onPressed: () {
                    audioPlayer.seek(Duration.zero,
                        index: audioPlayer.effectiveIndices!.first);
                  },
                  iconSize: 60,
                  icon: Icon(
                    Icons.replay_circle_filled_outlined,
                    color: Colors.blue.shade300,
                  ),
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
                }
                if (songIndex < widget.song.length - 1) {
                  setState(() {
                    songIndex += 1;
                  });
                }
              },
              icon: const Icon(
                Icons.skip_next,
              ),
            );
          },
        ),
      ],
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
}
