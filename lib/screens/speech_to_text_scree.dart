import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_music_app/widgets/audio_visualizer.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({super.key});

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  SpeechToText speechToText = SpeechToText();
  StreamSubscription? streamSubscription;
  String? text;
  bool? isListening;

  @override
  void initState() {
    initializeAudio();
    startListening();
    streamSubscription = Stream.periodic(const Duration(seconds: 2), (_) async {
      if (speechToText.isNotListening) {
        if (text != null) {
          await Future.delayed(const Duration(seconds: 2));
          if (context.mounted) Navigator.pop(context, text);
        } else {
          setState(() => isListening = false);
        }
      }
    }).listen((event) {});
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    speechToText.cancel();
    super.dispose();
  }

  initializeAudio() async {
    await speechToText.initialize();
  }

  startListening() async {
    setState(() => isListening = true);
    await speechToText.listen(
      listenOptions: SpeechListenOptions(cancelOnError: true),
      onResult: (result) {
        setState(() => text = result.recognizedWords);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                isListening == true ? text ?? "Speak" : "Press on the mic",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.black),
              ),
              Column(
                children: [
                  if (isListening == true) ...[AudioVisualizer()],
                  IconButton(
                    splashRadius: 50,
                    splashColor: Colors.blue,
                    color: Colors.blue[400],
                    onPressed: () {
                      if (speechToText.isListening) {
                        speechToText.stop();
                        setState(() => isListening = false);
                      } else {
                        startListening();
                        setState(() => isListening = true);
                        // text = "";
                      }
                    },
                    iconSize: 60,
                    icon: Icon(isListening == true ? Icons.stop_circle : Icons.mic),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
