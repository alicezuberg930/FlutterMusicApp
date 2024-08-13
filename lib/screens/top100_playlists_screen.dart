import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/models/section.dart';
import 'package:flutter_music_app/widgets/playlist_list.dart';
import 'package:flutter_music_app/widgets/section_header.dart';

class Top100PlaylistsScreen extends StatefulWidget {
  final List<Section> top100s;
  const Top100PlaylistsScreen({super.key, required this.top100s});

  @override
  State<Top100PlaylistsScreen> createState() => _Top100PlaylistsScreenState();
}

class _Top100PlaylistsScreenState extends State<Top100PlaylistsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade800.withOpacity(0.8),
        elevation: 0,
        title: const Text("Top 100s"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          shrinkWrap: true,
          itemCount: widget.top100s.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: SectionHeader(title: widget.top100s[index].title!),
                ),
                const SizedBox(height: 10),
                PlaylistList(playlists: widget.top100s[index].items as List<Playlist>),
              ],
            );
          },
        ),
      ),
    );
  }
}
