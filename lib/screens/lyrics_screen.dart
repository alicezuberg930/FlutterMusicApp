// ignore_for_file: implementation_imports

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_music_app/common/constants.dart';
import 'package:flutter_music_app/common/utils.dart';
import 'package:flutter_music_app/models/lyrics.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/services/api_service.dart';
import 'package:lyrics_parser/lyrics_parser.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:lyrics_parser/src/models.dart';

class LyricsScreen extends StatefulWidget {
  final Song song;
  final bool isOnline;
  const LyricsScreen({super.key, required this.song, required this.isOnline});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();
  List<LcrLyric> lyricsList = [];
  StreamSubscription? lyricsStream;
  bool? isLoading;

  @override
  void initState() {
    getLyrics();
    super.initState();
  }

  @override
  void dispose() {
    lyricsStream?.cancel();
    super.dispose();
  }

  getLyrics() async {
    setState(() => isLoading = true);
    String name = "${widget.song.artistsNames}-${widget.song.title}.lcr";
    Directory? appDocDir = await getDownloadsDirectory();
    File file = File("${appDocDir!.path}/lyrics/$name");
    if (widget.isOnline && !file.existsSync()) {
      Lyrics? lyrics = await ApiService.getLyrics(encodeId: widget.song.encodeId!);
      if (lyrics!.file == null) {
        setState(() {
          isLoading = false;
          lyricsList = [];
        });
        return;
      }
      await Utils.downloadLyrics(lyrics.file!, name);
    }
    if (!file.existsSync()) {
      setState(() {
        isLoading = false;
        lyricsList = [];
      });
      return;
    }
    LyricsParser parser = LyricsParser.fromFile(file);
    await parser.ready();
    LcrLyrics result = await parser.parse();
    setState(() {
      isLoading = false;
      lyricsList = result.lyricList;
    });
    lyricsStream = Constants.audioPlayer.positionStream.listen((e) {
      if (lyricsList.isNotEmpty) {
        DateTime dt = DateTime(1970, 1, 1).copyWith(
          hour: e.inHours,
          minute: e.inMinutes.remainder(60),
          second: e.inSeconds.remainder(60),
        );
        for (int i = 5; i < lyricsList.length; i++) {
          DateTime lyricsTimeStamp = DateTime(1970, 1, 1).copyWith(millisecond: lyricsList[i].startTimeMillisecond!.toInt());
          if (lyricsTimeStamp.isAfter(dt)) {
            itemScrollController.scrollTo(index: i - 5, duration: const Duration(milliseconds: 500));
            break;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF000000),
            Color(0xFF4C0053),
            Color(0xFFB471AE),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: widget.isOnline
                      ? Image(
                          image: Image.network(widget.song.thumbnail!).image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : QueryArtworkWidget(
                          id: int.parse(widget.song.encodeId!),
                          type: ArtworkType.AUDIO,
                          quality: 100,
                          artworkWidth: 50,
                          artworkHeight: 50,
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.song.title!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.song.artistsNames!,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.5)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<Duration>(
              stream: Constants.audioPlayer.positionStream,
              builder: (context, snapshot) {
                Duration duration = snapshot.data ?? const Duration(seconds: 0);
                DateTime dt = DateTime(1970, 1, 1).copyWith(
                  hour: duration.inHours,
                  minute: duration.inMinutes.remainder(60),
                  second: duration.inSeconds.remainder(60),
                );
                return isLoading!
                    ? const Center(child: CircularProgressIndicator(color: Colors.purple))
                    : lyricsList.isNotEmpty
                        ? ScrollablePositionedList.builder(
                            padding: const EdgeInsets.all(15),
                            itemCount: lyricsList.length,
                            itemBuilder: (context, index) {
                              int currentMiliSeconds = lyricsList[index].startTimeMillisecond!.toInt();
                              DateTime lyricsTimeStamp = DateTime(1970, 1, 1).copyWith(millisecond: currentMiliSeconds);
                              return Padding(
                                padding: EdgeInsets.only(bottom: index < lyricsList.length - 1 ? 15 : 0),
                                child: GestureDetector(
                                  onTap: () {
                                    Constants.audioPlayer.seek(Duration(milliseconds: currentMiliSeconds));
                                  },
                                  child: Text(
                                    lyricsList[index].content,
                                    style: TextStyle(
                                      color: lyricsTimeStamp.isAfter(dt) ? Colors.white38 : Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      wordSpacing: 1,
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemScrollController: itemScrollController,
                            scrollOffsetController: scrollOffsetController,
                            itemPositionsListener: itemPositionsListener,
                            scrollOffsetListener: scrollOffsetListener,
                          )
                        : const Center(
                            child: Text(
                            "No lyrics found",
                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                          ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
