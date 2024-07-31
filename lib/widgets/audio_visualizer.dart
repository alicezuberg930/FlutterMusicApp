// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class VisualComponent extends StatefulWidget {
  final int duration;
  final Color color;
  const VisualComponent({super.key, required this.duration, required this.color});

  @override
  State<VisualComponent> createState() => _VisualComponentState();
}

class _VisualComponentState extends State<VisualComponent> with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration));
    CurvedAnimation curvedAnimation = CurvedAnimation(parent: animationController!.view, curve: Curves.bounceInOut);
    animation = Tween<double>(begin: 0, end: 50).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });
    animationController!.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animation?.removeListener(() {});
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: animation!.value,
      decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(5)),
    );
  }
}

class AudioVisualizer extends StatelessWidget {
  AudioVisualizer({super.key});

  List<Color> colors = [
    Colors.blueAccent[700]!,
    Colors.blueAccent[400]!,
    Colors.blueAccent,
    Colors.blueAccent[100]!,
    Colors.blue[900]!,
    Colors.blue[800]!,
    Colors.blue[700]!,
    Colors.blue[600]!,
    Colors.blue,
    Colors.blue[400]!,
    Colors.blue[300]!,
    Colors.blue[200]!,
    Colors.blue[100]!
  ];
  List<int> durations = [220, 175, 150, 200, 125, 100, 150, 180, 210];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<Widget>.generate(
          30,
          (index) => VisualComponent(duration: durations[index % 5], color: colors[index % 4]),
        ),
      ),
    );
  }
}
