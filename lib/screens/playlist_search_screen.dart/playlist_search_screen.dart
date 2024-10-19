import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_app/common/constants.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/screens/playlist_search_screen.dart/cubit/playlist_search_cubit.dart';
import 'package:flutter_music_app/services/route_generator_service.dart';
import 'package:flutter_music_app/widgets/custom_search_bar.dart';
import 'package:flutter_music_app/widgets/song_card.dart';

class PlaylistSearchScreen extends StatefulWidget {
  const PlaylistSearchScreen({super.key});

  static BlocProvider<PlaylistSearchCubit> provider({required List<Song> songs}) {
    return BlocProvider(
      create: (context) => PlaylistSearchCubit(songs),
      child: const PlaylistSearchScreen(),
    );
  }

  @override
  State<PlaylistSearchScreen> createState() => _PlaylistSearchScreenState();
}

class _PlaylistSearchScreenState extends State<PlaylistSearchScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: CustomSearchBar(
          onChanged: (value) {
            context.read<PlaylistSearchCubit>().searchPlaylist(query: value);
          },
          onTap: () {
            Constants.navigatorKey!.currentState!.pushNamed(RouteGeneratorService.speechToTextScreen).then(
              (value) {
                if (value != null) {
                  searchController.clear();
                  searchController.text = value.toString();
                  context.read<PlaylistSearchCubit>().searchPlaylist(query: searchController.text);
                }
              },
            );
          },
          controller: searchController,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<PlaylistSearchCubit, PlaylistSearchState>(
            builder: (context, state) {
              if (state is SearchPlaylistState) {
                return state.songs!.isEmpty
                    ? const Center(child: Text("No songs found"))
                    : ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(height: 15),
                        shrinkWrap: true,
                        itemCount: state.songs!.length,
                        itemBuilder: (context, index) {
                          return SongCard(isOnline: true, index: index, songs: state.songs);
                        },
                      );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
