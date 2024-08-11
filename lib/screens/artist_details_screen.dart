import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/artist.dart';

class ArtistDetailsScreen extends StatefulWidget {
  final String encodeId;
  const ArtistDetailsScreen({super.key, required this.encodeId});

  @override
  State<ArtistDetailsScreen> createState() => _ArtistDetailsScreenState();
}

class _ArtistDetailsScreenState extends State<ArtistDetailsScreen> {
  Artist? artist;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
