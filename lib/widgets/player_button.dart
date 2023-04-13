import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerButton extends StatelessWidget {
  final AudioPlayer audioPlayer;
  const PlayerButton({Key? key, required this.audioPlayer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
          stream: audioPlayer.sequenceStateStream,
          builder: (context, snapshot) {
            return IconButton(
              color: Colors.blue.shade400,
              iconSize: 60,
              onPressed:
                  audioPlayer.hasPrevious ? audioPlayer.seekToPrevious : null,
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
              color: Colors.blue.shade300,
              iconSize: 60,
              onPressed: audioPlayer.hasNext ? audioPlayer.seekToNext : null,
              icon: const Icon(
                Icons.skip_next,
              ),
            );
          },
        ),
      ],
    );
  }
}
