import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Constants {
  static String apiUrl = "https://zingmp3api.onrender.com/api/v2";
  static GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static AudioPlayer audioPlayer = AudioPlayer();
  static String defaultAudio = "https://cdn.pixabay.com/download/audio/2022/02/10/audio_7a07ee0e79.mp3?filename=birds-19624.mp3";
}
