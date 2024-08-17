import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_music_app/common/constants.dart';
import 'package:flutter_music_app/screens/home_screen/home_screen.dart';
import 'package:flutter_music_app/services/http_service.dart';
import 'package:flutter_music_app/services/route_generator_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await FlutterDownloader.initialize(debug: false);
  await HttpService.initialize();
  Constants.audioPlayer = AudioPlayer();
  Constants.navigatorKey = GlobalKey<NavigatorState>();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Constants.navigatorKey,
      onGenerateRoute: RouteGeneratorService.generateRoute,
      scaffoldMessengerKey: Constants.rootScaffoldMessengerKey,
      home: HomeScreen.provider(),
      title: "Flutter music app",
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        primaryTextTheme: GoogleFonts.robotoTextTheme(),
        //   primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
