import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Taillz/models/change_model.dart';
import 'package:Taillz/screens/change/full_screen_video_player/full_screen_video_player.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:video_player/video_player.dart';

import '../m/change_response.dart';

class ControlsOverlay extends StatefulWidget {
  const ControlsOverlay(
      {Key? key,
      required this.controller,
      required this.model,
      required this.play})
      : super(key: key);

  final Payload model;
  final VideoPlayerController? controller;
  final bool play;

  @override
  State<ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<ControlsOverlay> {
  ChewieController? chewieController;
  double currentVol = 0.0;

  @override
  void initState() {
    super.initState();
    chewieController = ChewieController(
      videoPlayerController: widget.controller!,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      showControls: true,
    );
    widget.controller!.addListener(() {
      setState(() {});
    });

    if (widget.play) {
      widget.controller!.play();
      widget.controller!.setLooping(true);
    }

    PerfectVolumeControl.hideUI =
        false; //set if system UI is hided or not on volume up/down
    Future.delayed(Duration.zero, () async {
      currentVol = await PerfectVolumeControl.getVolume();
      setState(() {
        //refresh UI
      });
    });

    PerfectVolumeControl.stream.listen((volume) {
      setState(() {
        currentVol = volume;
      });
    });
  }

  @override
  void didUpdateWidget(ControlsOverlay oldWidget) {
    if (oldWidget.play != widget.play) {
      if (widget.play) {
        widget.controller!.play();
        widget.controller!.setLooping(true);
      } else {
        widget.controller!.pause();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: widget.controller!.value.aspectRatio,
              child: Stack(
                children: <Widget>[
                  Chewie(
                    controller: chewieController!,
                  ),
                  /*VideoPlayer(widget.controller!),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 50),
                    reverseDuration: const Duration(milliseconds: 200),
                    child: widget.controller!.value.isPlaying
                        ? const SizedBox.shrink()
                        : const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.play_circle_fill_rounded,
                              color: Colors.white,
                              size: 45,
                            ),
                          ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.controller!.value.isPlaying
                          ? widget.controller!.pause()
                          : widget.controller!.play();
                    },
                  ),
                  Positioned(
                    child: Chewie(
                      controller: chewieController!,
                    ),
                    bottom: 0,
                    right: 0,
                    left: 0,
                  )*/
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.60,
                ),
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    GestureDetector(
                      onTap: () {
                        widget.controller!.value.isPlaying
                            ? widget.controller!.pause()
                            : widget.controller!.play();
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 50),
                        reverseDuration: const Duration(milliseconds: 200),
                        child: widget.controller!.value.isPlaying
                            ? const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.pause_circle,
                            color: Colors.white,
                          ),
                        )
                            : const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    const Icon(
                      Icons.volume_up,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              currentVol -= 0.10;
                            });
                          },
                          child: const Icon(
                            Icons.minimize,
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.63,
                      child: Slider(
                        thumbColor: Colors.white,
                        activeColor: Theme.of(context).primaryColor,
                        inactiveColor: Colors.white,
                        value: currentVol,
                        onChanged: (newVol) {
                          currentVol = newVol;
                          PerfectVolumeControl.setVolume(
                              newVol); //set new volume
                          setState(() {});
                        },
                        min: 0,
                        //
                        max: 1,
                        divisions: 100,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          setState(() {
                            currentVol += 0.10;
                          });
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
