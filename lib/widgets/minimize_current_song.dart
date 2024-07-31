import 'package:flutter/material.dart';

class MinimizeCurrentSong extends StatefulWidget {
  const MinimizeCurrentSong({super.key});

  @override
  State<MinimizeCurrentSong> createState() => _MinimizeCurrentSongState();
}

class _MinimizeCurrentSongState extends State<MinimizeCurrentSong> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(),
    );
  }
}
