import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_app/common/constants.dart';
import 'package:flutter_music_app/common/debouncer.dart';
import 'package:flutter_music_app/common/utils.dart';
import 'package:flutter_music_app/models/artist.dart';
import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/models/video.dart';
import 'package:flutter_music_app/screens/search_screen/cubit/search_cubit.dart';
import 'package:flutter_music_app/services/route_generator_service.dart';
import 'package:flutter_music_app/widgets/song_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static BlocProvider<SearchCubit> provider() {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: const SearchScreen(),
    );
  }

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  List<Tab> tabList = const [
    Tab(child: Text("Songs")),
    Tab(child: Text("Playlists")),
    Tab(child: Text("Artists")),
    Tab(child: Text("MV")),
  ];
  TabController? tabController;
  TextEditingController searchController = TextEditingController();
  Debouncer debouncer = Debouncer(milliseconds: 1500);

  @override
  void initState() {
    tabController = TabController(length: tabList.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    searchController.dispose();
    debouncer.dispose();
    super.dispose();
  }

  searchedSongsWidget(List<Song> songs) {
    return ListView.separated(
      padding: const EdgeInsets.all(15),
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      shrinkWrap: true,
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return SongCard(isOnline: true, index: index, songs: songs);
      },
    );
  }

  searchedPlaylistsWidget(List<Playlist> playlists) {
    return ListView.separated(
      padding: const EdgeInsets.all(15),
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      shrinkWrap: true,
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Constants.navigatorKey!.currentState!.pushNamed(
              RouteGeneratorService.playlistDetailsScreen,
              arguments: {'encodeId': playlists[index].encodeId!},
            );
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: Image.network(playlists[index].thumbnail!).image,
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
                      playlists[index].title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      playlists[index].artistsNames!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
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

  searchedArtistsWidget(List<Artist> artists) {
    return ListView.separated(
      padding: const EdgeInsets.all(15),
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      shrinkWrap: true,
      itemCount: artists.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Constants.navigatorKey!.currentState!.pushNamed(
              RouteGeneratorService.artistDetailsScreen,
              arguments: {'alias': artists[index].alias},
            );
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image(
                  image: Image.network(artists[index].thumbnail!).image,
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
                      artists[index].name!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${Utils.formatNumber(artists[index].totalFollow!)} follows",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
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

  searchedMVWidgets(List<Video> videos) {
    return ListView.separated(
      padding: const EdgeInsets.all(15),
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      shrinkWrap: true,
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Constants.navigatorKey!.currentState!.pushNamed(
              RouteGeneratorService.videoPlayerScreen,
              arguments: {'encodeId': videos[index].encodeId!},
            );
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: Image.network(videos[index].thumbnail!).image,
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
                      videos[index].title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      videos[index].artistsNames!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
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

  searchBarWidget() {
    return TextFormField(
      onChanged: (value) {
        debouncer.run(() {
          context.read<SearchCubit>().search(query: value);
        });
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
          onTap: () {
            Constants.navigatorKey!.currentState!.pushNamed(RouteGeneratorService.speechToTextScreen).then(
              (value) {
                if (value != null) {
                  searchController.clear();
                  searchController.text = value.toString();
                  context.read<SearchCubit>().search(query: searchController.text);
                }
              },
            );
          },
          child: const Icon(Icons.mic, color: Colors.blue),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: searchBarWidget(),
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
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoadingState) {
                return const Center(child: CircularProgressIndicator(color: Colors.purple));
              }
              if (state is SearchResultState) {
                return state.searchResult != null && state.searchResult!.songs.isNotEmpty
                    ? searchedSongsWidget(state.searchResult!.songs)
                    : const Center(child: Text("No data"));
              }
              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoadingState) {
                return const Center(child: CircularProgressIndicator(color: Colors.purple));
              }
              if (state is SearchResultState) {
                return state.searchResult != null && state.searchResult!.playlists.isNotEmpty
                    ? searchedPlaylistsWidget(state.searchResult!.playlists)
                    : const Center(child: Text("No data"));
              }
              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoadingState) {
                return const Center(child: CircularProgressIndicator(color: Colors.purple));
              }
              if (state is SearchResultState) {
                return state.searchResult != null && state.searchResult!.artists.isNotEmpty
                    ? searchedArtistsWidget(state.searchResult!.artists)
                    : const Center(child: Text("No data"));
              }
              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoadingState) {
                return const Center(child: CircularProgressIndicator(color: Colors.purple));
              }
              if (state is SearchResultState) {
                return state.searchResult != null && state.searchResult!.videos.isNotEmpty
                    ? searchedMVWidgets(state.searchResult!.videos)
                    : const Center(child: Text("No data"));
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
