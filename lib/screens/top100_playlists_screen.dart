import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/top100.dart';
import 'package:flutter_music_app/widgets/horizontal_card_list.dart';
import 'package:flutter_music_app/widgets/section_header.dart';

class Top100PlaylistsScreen extends StatefulWidget {
  final List<Top100> top100s;
  const Top100PlaylistsScreen({super.key, required this.top100s});

  @override
  State<Top100PlaylistsScreen> createState() => _Top100PlaylistsScreenState();
}

class _Top100PlaylistsScreenState extends State<Top100PlaylistsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200.withOpacity(0.8),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Top 100s"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            shrinkWrap: true,
            itemCount: widget.top100s.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: SectionHeader(title: widget.top100s[index].title!, action: ''),
                  ),
                  const SizedBox(height: 10),
                  HorizontalCardList(playlists: widget.top100s[index].items),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
