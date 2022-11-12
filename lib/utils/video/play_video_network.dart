import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayVideoNetwork extends StatefulWidget {
  final String pathVideo;
  const PlayVideoNetwork({Key? key, required this.pathVideo}) : super(key: key);

  @override
  State<PlayVideoNetwork> createState() => _PlayVideoNetworkState();
}

class _PlayVideoNetworkState extends State<PlayVideoNetwork> {
  VideoPlayerController? _controller;
  bool isPlaying = false;
  Widget videoStatusAnimation = Container();
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.pathVideo)
      ..addListener(() {
        final bool isPlayingAdd = _controller!.value.isPlaying;
        if (isPlayingAdd != isPlaying) {
          setState(() {
            isPlaying = isPlayingAdd;
          });
        }
      })
      ..initialize().then((_) {
        Timer(const Duration(milliseconds: 0), () {
          if (!mounted) return;

          setState(() {});
          _controller!.play();
        });
      });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: _controller!.value.isInitialized ? videoPlayer() : Container(),
      );
  Widget videoPlayer() => Stack(
        children: <Widget>[
          video(),
          Align(
            alignment: Alignment.bottomCenter,
            child: VideoProgressIndicator(
              _controller!,
              allowScrubbing: true,
              padding: const EdgeInsets.all(16.0),
            ),
          ),
          Center(child: videoStatusAnimation),
        ],
      );
  Widget video() => GestureDetector(
        child: VideoPlayer(_controller!),
        onTap: () {
          if (!_controller!.value.isInitialized) {
            return;
          }
          if (_controller!.value.isPlaying) {
            videoStatusAnimation =
                const FadeAnimation(child: Icon(Icons.pause, size: 100.0));
            _controller!.pause();
          } else {
            videoStatusAnimation =
                const FadeAnimation(child: Icon(Icons.play_arrow, size: 100.0));
            _controller!.play();
          }
        },
      );
}

class FadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  const FadeAnimation(
      {Key? key,
      required this.child,
      this.duration = const Duration(milliseconds: 1000)})
      : super(key: key);

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    animationController!.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController!.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController!.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController!.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => animationController!.isAnimating
      ? Opacity(
          opacity: 1.0 - animationController!.value,
          child: widget.child,
        )
      : Container();
}
