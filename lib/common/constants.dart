import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Constants {
  static String apiUrl = "https://zingmp3.vn/";
  static GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static AudioPlayer audioPlayer = AudioPlayer();
  static String defaultAudio = "https://cdn.pixabay.com/download/audio/2022/02/10/audio_7a07ee0e79.mp3?filename=birds-19624.mp3";
  static String zingMP3Version = "1.6.34";
  static String secretKey = "2aa2d1c561e809b267f3638c4a307aab";
  static String apiKey = "88265e23d4284f25963e6eedac8fbfa3";
  static String ctime = (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString();
}
