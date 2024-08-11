import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/common/constants.dart';
import 'package:flutter_music_app/common/utils.dart';
import 'package:flutter_music_app/models/video.dart';
import 'package:flutter_music_app/services/api_service.dart';
import 'package:flutter_music_app/services/route_generator_service.dart';
import 'package:flutter_music_app/widgets/song_card.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String encodeId;

  const VideoPlayerScreen({super.key, required this.encodeId});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> with SingleTickerProviderStateMixin {
  VideoPlayerController? controller;
  Video? video;
  bool toggle = false;
  double? dragValue;
  bool displayControls = false;

  @override
  void initState() {
    ApiService.getVideo(encodeId: widget.encodeId).then((v) {
      setState(() {
        video = v!;
      });
      controller = VideoPlayerController.networkUrl(Uri.parse(video!.streaming?['360p'] ?? Constants.defaultVideo))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
          controller!.play();
        });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  backgroundFilter() {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            const Color(0xFFB471AE).withOpacity(0.7),
            const Color(0xFF000000).withOpacity(0.7),
            const Color(0xFF4C0053).withOpacity(0.7),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.srcATop,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  videoComponentWidget() {
    return controller != null && controller!.value.isInitialized
        ? Stack(
            children: [
              GestureDetector(
                onTap: () => setState(() => displayControls = !displayControls),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    AspectRatio(
                      aspectRatio: (16 / 9),
                      child: VideoPlayer(controller!),
                    ),
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      bottom: -5,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          thumbShape: RoundSliderThumbShape(
                            disabledThumbRadius: displayControls ? 5 : 0,
                            enabledThumbRadius: displayControls ? 5 : 0,
                          ),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                          activeTrackColor: Colors.purple,
                          inactiveTrackColor: Colors.grey.withOpacity(0.9),
                          thumbColor: Colors.white,
                          overlayColor: Colors.white,
                        ),
                        child: Slider(
                          min: 0.0,
                          max: controller!.value.duration.inMilliseconds.toDouble(),
                          value: min(
                            dragValue ?? controller!.value.position.inMilliseconds.toDouble(),
                            controller!.value.duration.inMilliseconds.toDouble(),
                          ),
                          onChanged: (value) async {
                            await controller!.seekTo(Duration(milliseconds: value.round()));
                            setState(() {
                              dragValue = value;
                            });
                          },
                          onChangeEnd: (value) {
                            setState(() {
                              dragValue = null;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * (9 / 16),
                child: displayControls
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => Constants.navigatorKey!.currentState!.pop(),
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.more_vert, color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                iconSize: 40,
                                onPressed: () async {},
                                icon: const Icon(Icons.skip_previous, color: Colors.white),
                              ),
                              IconButton(
                                iconSize: 40,
                                onPressed: () async {
                                  await controller!.seekTo((await controller!.position)! - const Duration(seconds: 10));
                                },
                                icon: const Icon(Icons.replay_10, color: Colors.white),
                              ),
                              IconButton(
                                iconSize: 70,
                                onPressed: () {
                                  setState(() {
                                    controller!.value.isPlaying ? controller!.pause() : controller!.play();
                                  });
                                },
                                icon: Icon(
                                  controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                iconSize: 40,
                                onPressed: () async {
                                  await controller!.seekTo((await controller!.position)! + const Duration(seconds: 10));
                                },
                                icon: const Icon(Icons.forward_10, color: Colors.white),
                              ),
                              IconButton(
                                iconSize: 40,
                                onPressed: () {},
                                icon: const Icon(Icons.skip_next, color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  "${Utils.formatDuration(controller!.value.position)}/${Utils.formatDuration(controller!.value.duration)}",
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.zoom_out_map, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              )
            ],
          )
        : SizedBox(
            height: MediaQuery.of(context).size.width * (9 / 16),
            child: const Center(child: CircularProgressIndicator(color: Colors.purple)),
          );
  }

  utilityWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            IconButton(
              iconSize: 35,
              onPressed: () {},
              icon: const Icon(CupertinoIcons.heart, color: Colors.white),
            ),
            const Text("Like"),
          ],
        ),
        Column(
          children: [
            IconButton(
              iconSize: 35,
              onPressed: () async {
                await Share.share(
                  "${Constants.apiUrl}${video!.link!.substring(1)}",
                  subject: "Check out this music video",
                );
              },
              icon: const Icon(Icons.share, color: Colors.white),
            ),
            const Text("Share"),
          ],
        ),
        Column(
          children: [
            IconButton(
              iconSize: 35,
              onPressed: () {
                infoModalBottomSheet();
              },
              icon: const Icon(Icons.info_outline, color: Colors.white),
            ),
            const Text("Info"),
          ],
        )
      ],
    );
  }

  artistWidget() {
    return Column(
      children: [
        const Divider(color: Colors.grey),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(video!.artist!.thumbnail!),
          ),
          title: Text(video!.artist!.name ?? "Not found"),
          subtitle: Text(
            "${(video!.like ?? 0).toString()} followers",
            style: TextStyle(color: Colors.grey[300]),
          ),
          trailing: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: const Text("Follow"),
          ),
        ),
        const Divider(color: Colors.grey),
      ],
    );
  }

  recommendVideoListWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Next video",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  const Text("Autoplay"),
                  CupertinoSwitch(
                    trackColor: Colors.purple[300],
                    activeColor: Colors.purple,
                    value: toggle,
                    onChanged: (value) {
                      setState(() {
                        toggle = value;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: video!.recommends.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(13),
              child: GestureDetector(
                onTap: () {
                  Constants.navigatorKey!.currentState!.pushNamed(
                    RouteGeneratorService.videoPlayerScreen,
                    arguments: {'encodeId': video!.recommends[index].encodeId!},
                  );
                },
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            video!.recommends[index].thumbnailM!,
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
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            Utils.formatDuration(Duration(seconds: video!.recommends[index].duration!)),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            video!.recommends[index].artist!.thumbnail!,
                            width: 50,
                            height: 50,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video!.recommends[index].title!,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(video!.recommends[index].artistsNames!),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }

  infoModalBottomSheet() {
    return showModalBottomSheet(
      useSafeArea: true,
      backgroundColor: Colors.black,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        const Text("Information", style: TextStyle(fontWeight: FontWeight.bold)),
                        InkWell(
                          onTap: () => Constants.navigatorKey!.currentState!.pop(),
                          child: const Icon(Icons.cancel, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey.withOpacity(0.5)),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Text("Artists:", style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 10),
                      Text(
                        video!.artistsNames!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Genres:", style: TextStyle(color: Colors.grey), maxLines: 2),
                      const SizedBox(width: 10),
                      Text(
                        video!.genreNames,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Composers:", style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          video!.composerNames,
                          maxLines: 3,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  if (video!.song != null) ...[
                    const SizedBox(height: 30),
                    const Text("Audio", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                    const SizedBox(height: 10),
                    SongCard(isOnline: true, songs: [video!.song!], textColor: Colors.white),
                  ],
                  const SizedBox(height: 30),
                  const Text("Lyrics", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  const SizedBox(height: 10),
                  Text(
                    video!.lyrics!.replaceAll("<br>", ""),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            backgroundFilter(),
            Column(
              children: [
                videoComponentWidget(),
                if (video != null) ...[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              video!.title ?? "Not found",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          utilityWidget(),
                          const SizedBox(height: 20),
                          artistWidget(),
                          const SizedBox(height: 10),
                          recommendVideoListWidget()
                        ],
                      ),
                    ),
                  )
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
