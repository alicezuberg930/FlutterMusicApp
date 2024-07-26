import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/playlist.dart';

class PlayListDetailsScreen extends StatefulWidget {
  final Playlist playlist;
  const PlayListDetailsScreen({super.key, required this.playlist});

  @override
  State<PlayListDetailsScreen> createState() => _PlayListDetailsScreenState();
}

class _PlayListDetailsScreenState extends State<PlayListDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
