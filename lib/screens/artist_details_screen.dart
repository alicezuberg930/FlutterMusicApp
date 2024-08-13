import 'package:flutter/material.dart';
import 'package:flutter_music_app/common/constants.dart';
import 'package:flutter_music_app/common/utils.dart';
import 'package:flutter_music_app/models/artist.dart';
import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/models/section.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/models/video.dart';
import 'package:flutter_music_app/services/api_service.dart';
import 'package:flutter_music_app/services/route_generator_service.dart';
import 'package:flutter_music_app/widgets/playlist_card.dart';
import 'package:flutter_music_app/widgets/playlist_list.dart';
import 'package:flutter_music_app/widgets/section_header.dart';
import 'package:flutter_music_app/widgets/song_card.dart';

class ArtistDetailsScreen extends StatefulWidget {
  final String alias;
  const ArtistDetailsScreen({super.key, required this.alias});

  @override
  State<ArtistDetailsScreen> createState() => _ArtistDetailsScreenState();
}

class _ArtistDetailsScreenState extends State<ArtistDetailsScreen> {
  Artist? artist;

  @override
  void initState() {
    ApiService.getArtist(name: widget.alias).then((value) {
      setState(() {
        artist = value;
      });
    });
    super.initState();
  }

  topAlbumWidget() {
    return artist!.topAlbum != null
        ? Container(
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(8),
            child: PlaylistCard(
              playlist: artist!.topAlbum!,
              axis: Axis.horizontal,
            ),
          )
        : const SizedBox.shrink();
  }

  outstandingSongsWidget(Section section) {
    return Column(
      children: [
        const SizedBox(height: 20),
        SectionHeader(
          title: section.title!,
          action: const Icon(Icons.arrow_forward_ios, color: Colors.black),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          shrinkWrap: true,
          itemCount: section.items.length,
          itemBuilder: (context, index) {
            if (index <= 9) {
              return SongCard(isOnline: true, index: index, songs: section.items as List<Song>);
            }
            return null;
          },
        ),
        GestureDetector(
          onTap: () => Constants.navigatorKey!.currentState!.pushNamed(
            RouteGeneratorService.allSongScreen,
            arguments: {'songs': section.items},
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black.withOpacity(0.2)),
            ),
            child: const Text("See more"),
          ),
        ),
      ],
    );
  }

  singleEPPlaylistsWidget(Section section) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // Constants.navigatorKey!.currentState!.pushNamed(
            //   RouteGeneratorService.top100PlaylistScreen,
            //   arguments: {'top100s': top100s},
            // );
          },
          child: SectionHeader(
            title: section.title!,
            action: const Icon(Icons.arrow_forward_ios, color: Colors.black),
          ),
        ),
        const SizedBox(height: 10),
        PlaylistList(playlists: section.items as List<Playlist>),
      ],
    );
  }

  albumWidget(Section section) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // Constants.navigatorKey!.currentState!.pushNamed(
            //   RouteGeneratorService.top100PlaylistScreen,
            //   arguments: {'top100s': top100s},
            // );
          },
          child: SectionHeader(
            title: section.title!,
            action: const Icon(Icons.arrow_forward_ios, color: Colors.black),
          ),
        ),
        const SizedBox(height: 10),
        PlaylistList(playlists: section.items as List<Playlist>),
      ],
    );
  }

  musicVideoWidget(Section section) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // Constants.navigatorKey!.currentState!.pushNamed(
            //   RouteGeneratorService.top100PlaylistScreen,
            //   arguments: {'top100s': top100s},
            // );
          },
          child: SectionHeader(
            title: section.title!,
            action: const Icon(Icons.arrow_forward_ios, color: Colors.black),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.width * (9 / 16) + 50,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: section.items.length,
            itemBuilder: (context, index) {
              Video video = section.items[index];
              return GestureDetector(
                onTap: () {
                  Constants.navigatorKey!.currentState!.pushNamed(
                    RouteGeneratorService.videoPlayerScreen,
                    arguments: {'encodeId': video.encodeId!},
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            video.thumbnailM!,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * (9 / 16),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            Utils.formatDuration(Duration(seconds: video.duration!)),
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(video.artistsNames!),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  playlistsWidget(Section section) {
    return Column(
      children: [
        SectionHeader(title: section.title!),
        const SizedBox(height: 10),
        PlaylistList(playlists: section.items as List<Playlist>),
      ],
    );
  }

  artistsYouMayLikeWidget(Section section) {
    return Column(
      children: [
        SectionHeader(title: section.title!),
        const SizedBox(height: 10),
        SizedBox(
          height: 195,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: section.items.length,
            itemBuilder: (context, index) {
              Artist art = section.items[index];
              return GestureDetector(
                onTap: () {
                  Constants.navigatorKey!.currentState!.pushNamed(
                    RouteGeneratorService.artistDetailsScreen,
                    arguments: {'alias': art.alias!},
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                        image: Image.network(art.thumbnailM!).image,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          art.name!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${(art.totalFollow ?? 0).toString()} followers",
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  informationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Text("Information", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(artist!.biography!.replaceAll("<br>", "")),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text("Real name", style: TextStyle(color: Colors.grey)),
            const SizedBox(width: 20),
            Text(artist!.realname!),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text("Birthday", style: TextStyle(color: Colors.grey)),
            const SizedBox(width: 20),
            Text(artist!.birthday!),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text("Nationality", style: TextStyle(color: Colors.grey)),
            const SizedBox(width: 20),
            Text(artist!.national!),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  artistSectionListWidget() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 30),
      itemCount: artist!.sections!.length,
      itemBuilder: (context, index) {
        Section section = artist!.sections![index];
        return Column(
          children: [
            if (section.sectionId == "aSongs") ...[outstandingSongsWidget(section)],
            if (section.sectionId == "aSingle") ...[singleEPPlaylistsWidget(section)],
            if (section.sectionId == "aAlbum") ...[albumWidget(section)],
            if (section.sectionId == "aMV") ...[musicVideoWidget(section)],
            if (section.sectionId == "aPlaylist") ...[playlistsWidget(section)],
            if (section.sectionId == "aReArtist") ...[artistsYouMayLikeWidget(section)],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: artist != null
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      topAlbumWidget(),
                      artistSectionListWidget(),
                      informationWidget(),
                    ],
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator(color: Colors.purple)),
      ),
    );
  }
}
