import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/models/top100.dart';
import 'package:flutter_music_app/screens/artist_details_screen.dart';
import 'package:flutter_music_app/screens/home_screen.dart';
import 'package:flutter_music_app/screens/new_release_screen.dart';
import 'package:flutter_music_app/screens/playlist_details_screen.dart';
import 'package:flutter_music_app/screens/search_screen.dart';
import 'package:flutter_music_app/screens/speech_to_text_scree.dart';
import 'package:flutter_music_app/screens/top100_playlists_screen.dart';
import 'package:flutter_music_app/screens/video_player_screen.dart';

class RouteGeneratorService {
  static const String artistDetailsScreen = '/artist-details-screen';
  static const String homeScreen = '/home-screen';
  static const String newReleaseScreen = '/new-release-screen';
  static const String playlistDetailsScreen = '/playlist-details-screen';
  static const String searchScreen = '/search-screen';
  static const String speechToTextScreen = '/speech-to-text-screen';
  static const String top100PlaylistScreen = '/top-100-playlist-screen';
  static const String videoPlayerScreen = '/video-player-screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map<String, dynamic> map = settings.arguments != null ? settings.arguments as Map<String, dynamic> : {};
    switch (settings.name) {
      case artistDetailsScreen:
        return pageRouteBuilder(ArtistDetailsScreen(encodeId: map['encodeId'] as String), settings);
      case homeScreen:
        return pageRouteBuilder(const HomeScreen(), settings);
      case newReleaseScreen:
        return pageRouteBuilder(NewReleaseScreen(songs: map['songs'] as List<Song>), settings);
      case playlistDetailsScreen:
        return pageRouteBuilder(PlayListDetailsScreen(encodeId: map['encodeId'] as String), settings);
      case searchScreen:
        return pageRouteBuilder(const SearchScreen(), settings);
      case speechToTextScreen:
        return pageRouteBuilder(const SpeechToTextScreen(), settings);
      case top100PlaylistScreen:
        return pageRouteBuilder(Top100PlaylistsScreen(top100s: map['top100s'] as List<Top100>), settings);
      case videoPlayerScreen:
        return pageRouteBuilder(VideoPlayerScreen(encodeId: map['encodeId'] as String), settings);
      default:
        return errorRoute();
    }
  }

  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('error'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Screen not found'),
        ),
      );
    });
  }

  static pageRouteBuilder(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset(0, 0);
        const curve = Curves.ease;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
