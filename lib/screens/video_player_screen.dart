import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/common/utils.dart';
import 'package:flutter_music_app/models/video.dart';
import 'package:flutter_music_app/services/api_service.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String encodeId;

  const VideoPlayerScreen({super.key, required this.encodeId});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> with SingleTickerProviderStateMixin {
  late VideoPlayerController controller;
  Video? video;
  AnimationController? animationController;
  bool toggle = false;
  double? dragValue;

  @override
  void initState() {
    ApiService.getVideo(encodeId: widget.encodeId).then((v) {
      setState(() {
        video = v!;
      });
    });
    controller = VideoPlayerController.networkUrl(Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 10))
      ..addListener(() {
        setState(() {});
      });
    animationController!.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    animationController?.dispose();
    super.dispose();
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
                            padding: const EdgeInsets.only(top: 20, left: 20),
                            child: Text(
                              video!.title ?? "None",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 20),
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
    return SizedBox(
      height: MediaQuery.of(context).size.width * (9 / 16),
      child: controller.value.isInitialized
          ? Column(
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: (16 / 9),
                      child: VideoPlayer(controller),
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 40,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              iconSize: 40,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.replay_circle_filled,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              iconSize: 70,
                              onPressed: () {
                                setState(() {
                                  controller.value.isPlaying ? controller.pause() : controller.play();
                                });
                              },
                              icon: Icon(
                                controller.value.isPlaying ? Icons.pause_circle_outline : Icons.play_arrow_outlined,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              iconSize: 40,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.replay_circle_filled,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              iconSize: 40,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.skip_next,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text("00:23/03:03"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: InkWell(
                                onTap: () {},
                                child: const Icon(
                                  Icons.zoom_out_map,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 1,
                            thumbShape: const RoundSliderThumbShape(disabledThumbRadius: 6, enabledThumbRadius: 6),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: Colors.grey.withOpacity(0.5),
                            thumbColor: Colors.white,
                            overlayColor: Colors.white,
                          ),
                          child: Slider(
                            min: 0.0,
                            max: controller.value.duration.inSeconds.toDouble(),
                            value: min(
                              dragValue ?? controller.value.position.inSeconds.toDouble(),
                              controller.value.duration.inSeconds.toDouble(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                dragValue = value;
                              });
                              // if (widget.onchange != null) {
                              //   widget.onchange!(Duration(milliseconds: value.round()));
                              // }
                            },
                            onChangeEnd: (value) {
                              // if (widget.onchangeEnd != null) {
                              //   widget.onchangeEnd!(Duration(milliseconds: value.round()));
                              // }
                              setState(() {
                                dragValue = null;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator(color: Colors.purple)),
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
              onPressed: () {},
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
            child: Image.network(video!.artist!.thumbnail ?? ""),
          ),
          title: Text(video!.artist!.name ?? "None"),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(encodeId: video!.recommends[index].encodeId!),
                    ),
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
                            video!.recommends[index].thumbnail!,
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
      backgroundColor: Colors.black,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width * (9.8 / 16),
              child: Text(
                video!.lyrics!.replaceAll("<br>", ""),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }
}
