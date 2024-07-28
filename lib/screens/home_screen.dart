import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/models/top100.dart';
import 'package:flutter_music_app/screens/local_audio_screen.dart';
import 'package:flutter_music_app/screens/new_release_screen.dart';
import 'package:flutter_music_app/screens/top100_playlists_screen.dart';
import 'package:flutter_music_app/services/api_service.dart';
import 'package:flutter_music_app/widgets/custom_appbar.dart';
import 'package:flutter_music_app/widgets/horizontal_card_list.dart';
import 'package:flutter_music_app/widgets/section_header.dart';
import 'package:flutter_music_app/widgets/song_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  PageController pageController = PageController();
  int selectedIndex = 0;
  List<Song> newReleaseSongs = [];
  List<Top100> top100s = [];
  ApiService apiService = ApiService();

  @override
  void initState() {
    getHome();
    getTop100Playlist();
    super.initState();
  }

  getHome() async {
    List<Song> temp = await apiService.getHome();
    setState(() => newReleaseSongs = temp);
  }

  getTop100Playlist() async {
    List<Top100>? temp = await apiService.getTop100();
    setState(() => top100s = temp);
  }

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
        appBar: const CustomAppbar(),
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
                  searchWidget(),
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
      ),
    );
  }

  searchWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome',
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
          const SizedBox(height: 5),
          Text(
            'Enjoy your favorite music',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onFieldSubmitted: (value) async {
              await apiService.getHome();
              // print(value);
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.purple[200],
              hintText: "Tìm kiếm",
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              labelStyle: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  newReleaseSongsWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewReleaseScreen(songs: newReleaseSongs),
                ),
              );
            },
            child: const SectionHeader(title: 'New release'),
          ),
          const SizedBox(height: 10),
          newReleaseSongs.isNotEmpty
              ? ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(height: 15),
                  shrinkWrap: true,
                  itemCount: newReleaseSongs.length,
                  itemBuilder: (context, index) {
                    if (index <= 4) {
                      return SongCard(song: newReleaseSongs[index], isOnline: true);
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Top100PlaylistsScreen(top100s: top100s),
                ),
              );
            },
            child: const SectionHeader(title: 'Top 100'),
          ),
          const SizedBox(height: 10),
          top100s.isNotEmpty ? HorizontalCardList(playlists: top100s[0].items) : const CircularProgressIndicator(color: Colors.purple),
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
          label: "Trang chủ",
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
}
