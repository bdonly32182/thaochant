import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayVideo extends StatefulWidget {
  File fileVideo;
  PlayVideo({Key? key, required this.fileVideo}) : super(key: key);

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  VideoPlayerController? _controller;
  bool isPlaying = false;
  Widget videoStatusAnimation = Container();
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.fileVideo)
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
        aspectRatio: 16 / 9,
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
              padding: EdgeInsets.all(16.0),
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
                FadeAnimation(child: const Icon(Icons.pause, size: 100.0));
            _controller!.pause();
          } else {
            videoStatusAnimation =
                FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
            _controller!.play();
          }
        },
      );
}

class FadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  FadeAnimation(
      {required this.child,
      this.duration = const Duration(milliseconds: 1000)});

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
