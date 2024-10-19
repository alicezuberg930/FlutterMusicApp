import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_app/common/constants.dart';
import 'package:flutter_music_app/screens/playlist_details_screen/cubit/playlist_details_cubit.dart';
import 'package:flutter_music_app/services/route_generator_service.dart';
import 'package:flutter_music_app/widgets/minimize_current_song.dart';
import 'package:flutter_music_app/widgets/song_card.dart';

class PlayListDetailsScreen extends StatefulWidget {
  final String encodeId;
  const PlayListDetailsScreen({super.key, required this.encodeId});

  static BlocProvider<PlaylistDetailsCubit> provider({required String encodeId}) {
    return BlocProvider(
      create: (context) => PlaylistDetailsCubit(),
      child: PlayListDetailsScreen(encodeId: encodeId),
    );
  }

  @override
  State<PlayListDetailsScreen> createState() => _PlayListDetailsScreenState();
}

class _PlayListDetailsScreenState extends State<PlayListDetailsScreen> {
  @override
  void initState() {
    context.read<PlaylistDetailsCubit>().getPlaylistDetails(encodeId: widget.encodeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: const MinimizeCurrentSong(),
      body: SafeArea(
        child: BlocBuilder<PlaylistDetailsCubit, PlaylistDetailsState>(
          builder: (context, state) {
            if (state is PlaylistDetailsLoadingState) {
              return const Center(child: CircularProgressIndicator(color: Colors.purple));
            }
            if (state is GetPlaylistDetailsState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: Constants.audioPlayer.sequence != null ? 90 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          Constants.navigatorKey!.currentState!.pop();
                                          Constants.navigatorKey!.currentState!.pushNamed(
                                            RouteGeneratorService.playlistSearchScreen,
                                            arguments: {'songs': state.playlist!.songs},
                                          );
                                        },
                                        leading: const Icon(Icons.search, color: Colors.black),
                                        title: const Text("Search songs/artists", style: TextStyle(color: Colors.black)),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.more_vert),
                          )
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          state.playlist!.thumbnailM!,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        state.playlist!.title!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${state.playlist?.songs.length ?? 0} songs * ${state.totalTime}",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.black.withOpacity(0.5)),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: const Icon(Icons.download_sharp),
                              ),
                              const Text("Download", style: TextStyle(color: Colors.black, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 25),
                              backgroundColor: Colors.deepPurple.shade800,
                            ),
                            onPressed: () {},
                            child: const Text(
                              "PLAY RANDOM",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: const Icon(CupertinoIcons.heart),
                              ),
                              const Text("Favorite", style: TextStyle(color: Colors.black, fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        state.playlist!.sortDescription!,
                        style: const TextStyle(color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      state.playlist!.songs.isEmpty
                          ? const Center(child: Text("No songs found"))
                          : ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => const SizedBox(height: 15),
                              shrinkWrap: true,
                              itemCount: state.playlist!.songs.length,
                              itemBuilder: (context, index) {
                                return SongCard(isOnline: true, index: index, songs: state.playlist!.songs);
                              },
                            ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
