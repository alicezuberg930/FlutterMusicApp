import 'package:flutter/material.dart';

class PlaylistSearchScreen extends StatefulWidget {
  
  const PlaylistSearchScreen({super.key});

  @override
  State<PlaylistSearchScreen> createState() => _PlaylistSearchScreenState();
}

class _PlaylistSearchScreenState extends State<PlaylistSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(child: TextFormField()),
    );
  }
}
