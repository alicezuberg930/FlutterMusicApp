import 'package:flutter/material.dart';
import 'package:flutter_music_app/common/constants.dart';
import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/models/section.dart';
import 'package:flutter_music_app/screens/local_audio_screen.dart';
import 'package:flutter_music_app/services/api_service.dart';
import 'package:flutter_music_app/services/route_generator_service.dart';
import 'package:flutter_music_app/widgets/playlist_list.dart';
import 'package:flutter_music_app/widgets/minimize_current_song.dart';
import 'package:flutter_music_app/widgets/section_header.dart';
import 'package:flutter_music_app/widgets/song_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> with TickerProviderStateMixin {
  PageController pageController = PageController();
  int selectedIndex = 0;
  List<Song> newReleaseSongs = [];
  List<Section> top100s = [];
  ApiService apiService = ApiService();

  @override
  void initState() {
    getHome();
    getTop100Playlist();
    super.initState();
  }

  getHome() async {
    List<Song> temp = await ApiService.getHome();
    setState(() => newReleaseSongs = temp);
  }

  getTop100Playlist() async {
    List<Section>? temp = await ApiService.getTop100();
    setState(() => top100s = temp);
  }

  newReleaseSongsWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Constants.navigatorKey!.currentState!.pushNamed(
                RouteGeneratorService.allSongScreen,
                arguments: {'songs': newReleaseSongs},
              );
            },
            child: SectionHeader(
              title: 'New release',
              action: const Icon(Icons.arrow_forward_ios, color: Colors.black),
            ),
          ),
          const SizedBox(height: 10),
          newReleaseSongs.isNotEmpty
              ? ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(height: 15),
                  shrinkWrap: true,
                  itemCount: newReleaseSongs.length,
                  itemBuilder: (context, index) {
                    if (index <= 9) {
                      return SongCard(isOnline: true, index: index, songs: newReleaseSongs);
                    }
                    return null;
                  },
                )
              : const CircularProgressIndicator(color: Colors.purple),
        ],
      ),
    );
  }

  top100PlaylistWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Constants.navigatorKey!.currentState!.pushNamed(
                RouteGeneratorService.top100PlaylistScreen,
                arguments: {'top100s': top100s},
              );
            },
            child: SectionHeader(
              title: 'Top 100',
              action: const Icon(Icons.arrow_forward_ios, color: Colors.black),
            ),
          ),
          const SizedBox(height: 10),
          top100s.isNotEmpty ? PlaylistList(playlists: top100s[0].items as List<Playlist>) : const CircularProgressIndicator(color: Colors.purple)
        ],
      ),
    );
  }

  customNavigationBar() {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (value) {
        pageController.animateToPage(
          value,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      },
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      backgroundColor: Colors.deepPurple.shade800,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: "Favorite",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_fill_outlined),
          label: "Local",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: "Profile",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        elevation: 0,
        leading: const Icon(Icons.grid_view_rounded),
        actions: [
          GestureDetector(
            onTap: () async {
              Constants.navigatorKey!.currentState!.pushNamed(RouteGeneratorService.searchScreen);
            },
            child: const Icon(Icons.search),
          ),
          const SizedBox(width: 15),
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://i.pinimg.com/736x/9d/a3/b0/9da3b06254942ad9bc0287d425dd0c70.jpg'),
          ),
          const SizedBox(width: 15),
        ],
      ),
      bottomNavigationBar: customNavigationBar(),
      body: PageView(
        controller: pageController,
        onPageChanged: (value) {
          setState(() => selectedIndex = value);
        },
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                newReleaseSongsWidget(),
                top100PlaylistWidget(),
              ],
            ),
          ),
          const Text("Favorite"),
          const LocalAudioScreen(),
          const Text("Profile"),
        ],
      ),
      bottomSheet: Constants.audioPlayer.currentIndex != null ? const MinimizeCurrentSong() : null,
    );
  }
}
