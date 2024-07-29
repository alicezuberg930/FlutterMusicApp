import 'package:flutter/material.dart';
import 'package:flutter_music_app/common/ui_helpers.dart';
import 'package:flutter_music_app/models/search.dart';
import 'package:flutter_music_app/screens/playlist_details_screen.dart';
import 'package:flutter_music_app/services/api_service.dart';
import 'package:flutter_music_app/widgets/song_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  Search? searchData;
  ApiService apiService = ApiService();
  List<Tab> tabList = const [
    Tab(child: Text("Songs")),
    Tab(child: Text("Playlists")),
    Tab(child: Text("Artists")),
    Tab(child: Text("MV")),
  ];
  TabController? tabController;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    tabController = TabController(length: tabList.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    searchController.dispose();
    super.dispose();
  }

  fetchSearchData() {
    if (searchController.text.length > 3) {
      apiService.search(query: searchController.text).then((value) {
        setState(() => searchData = value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: TextFormField(
          onChanged: (value) async {
            await Future.delayed(const Duration(seconds: 4));
            fetchSearchData();
          },
          controller: searchController,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: "Type your query",
            hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),
            prefixIcon: const Icon(Icons.search, color: Colors.black),
            suffixIcon: GestureDetector(
              onTap: () => UIHelpers.showSnackBar(message: "to be implemented in the future"),
              child: const Icon(Icons.mic, color: Colors.blue),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: TabBar(
            labelColor: Colors.grey[600],
            indicatorColor: Colors.purple,
            controller: tabController,
            tabs: tabList,
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          searchedSongsWidget(),
          searchedPlaylistsWidget(),
          searchedArtistsWidget(),
          searchedMVWidgets(),
        ],
      ),
    );
  }

  searchedSongsWidget() {
    return searchData == null
        ? const Center(child: CircularProgressIndicator(color: Colors.purple))
        : searchData!.songs.isEmpty
            ? const Center(child: Text("No songs found", style: TextStyle(color: Colors.black)))
            : ListView.separated(
                padding: const EdgeInsets.all(15),
                separatorBuilder: (context, index) => const SizedBox(height: 15),
                shrinkWrap: true,
                itemCount: searchData!.songs.length,
                itemBuilder: (context, index) {
                  return SongCard(song: searchData!.songs[index], isOnline: true);
                },
              );
  }

  searchedPlaylistsWidget() {
    return searchData == null
        ? const Center(child: CircularProgressIndicator(color: Colors.purple))
        : searchData!.playlists.isEmpty
            ? const Center(child: Text("No playlists found", style: TextStyle(color: Colors.black)))
            : ListView.separated(
                padding: const EdgeInsets.all(15),
                separatorBuilder: (context, index) => const SizedBox(height: 15),
                shrinkWrap: true,
                itemCount: searchData!.playlists.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayListDetailsScreen(encodeId: searchData!.playlists[index].encodeId!),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: Image.network(searchData!.playlists[index].thumbnail!).image,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                searchData!.playlists[index].title!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                searchData!.playlists[index].artistsNames!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey),
                      ],
                    ),
                  );
                },
              );
  }

  searchedArtistsWidget() {
    return searchData == null
        ? const Center(child: CircularProgressIndicator(color: Colors.purple))
        : searchData!.artists.isEmpty
            ? const Center(child: Text("No artists found", style: TextStyle(color: Colors.black)))
            : ListView.separated(
                padding: const EdgeInsets.all(15),
                separatorBuilder: (context, index) => const SizedBox(height: 15),
                shrinkWrap: true,
                itemCount: searchData!.artists.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PlayListDetailsScreen(encodeId: searchData!.playlists[index].encodeId!),
                      //   ),
                      // );
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image(
                            image: Image.network(searchData!.artists[index].thumbnail!).image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                searchData!.artists[index].name!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${searchData!.artists[index].totalFollow.toString()} follows",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey),
                      ],
                    ),
                  );
                },
              );
  }

  searchedMVWidgets() {
    return searchData == null
        ? const Center(child: CircularProgressIndicator(color: Colors.purple))
        : searchData!.videos.isEmpty
            ? const Center(child: Text("No music videos found", style: TextStyle(color: Colors.black)))
            : ListView.separated(
                padding: const EdgeInsets.all(15),
                separatorBuilder: (context, index) => const SizedBox(height: 15),
                shrinkWrap: true,
                itemCount: searchData!.videos.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PlayListDetailsScreen(encodeId: searchData!.playlists[index].encodeId!),
                      //   ),
                      // );
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: Image.network(searchData!.videos[index].thumbnail!).image,
                            width: 100,
                            height: 55,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                searchData!.videos[index].title!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                searchData!.videos[index].artistsNames!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.more_vert),
                      ],
                    ),
                  );
                },
              );
  }
}
