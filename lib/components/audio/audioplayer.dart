import 'package:audioplayers/audioplayers.dart';
import 'package:chatapp/tools/ui_tools.dart';
import 'package:flutter/material.dart';

import 'noise.dart';

class AudioPlayerWidget extends StatefulWidget {
  AudioPlayerWidget({super.key, this.audioUrl});

  String? audioUrl;
  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> with SingleTickerProviderStateMixin {

  AnimationController? _controller;

  double value = 0.0;

  GlobalKey KeyNoise = GlobalKey();

  int maxduration = 8;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  bool isPlaying = false;

  final player = AudioPlayer();



  @override
  void initState() {
    super.initState();

    ///
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 95,
      duration: Duration(seconds: duration.inSeconds),
    );

    ///
    _controller!.addListener(() {
      if (_controller!.isCompleted) {
        _controller!.reset();
        setState(() {});
      }
    });

    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    player.onPositionChanged.listen((newPosition) { 
      setState(() {
        position = newPosition;
        _controller!.value = (95*newPosition.inSeconds)/duration.inSeconds;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    player.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        height: 60,
        width: 170,
        decoration: BoxDecoration(
          color: SecondColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ButtonPlay(),
            SizedBox(width: 10,),
            ElementAudio(),
          ],
        ),
      ),
    );
  }

  ButtonPlay() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: White,
      ),
      child: isPlaying == true ? IconButton(onPressed: () {
        setState(() {
          isPlaying = false;
        });
        player.pause();
      }, icon: Icon(Icons.pause)) : IconButton(onPressed: () {
        setState(() {
          isPlaying = true;
        });
        player.play(UrlSource(widget.audioUrl!));
      }, icon: Icon(Icons.play_arrow)),
    );
  }

  ElementAudio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 10,),
        Stack(
          children: [
            const Noise(),
            Positioned(
              left: _controller!.value,
              child: Container(
                height: 30,
                width: 95,
                color: SecondColor.withOpacity(0.4),
              ),
            ),
            Opacity(
              opacity: .0,
              child: Container(
                width: 95,
                height: 30,
                color: Colors.transparent,
                child: Slider(
                  value: position.inSeconds.toDouble(),
                  min: 0.0,
                  max: duration.inSeconds.toDouble(), 
                  onChanged: (Value) {
                    setState(() {
                      value = Value;
                      _controller!.value = (95*value)/duration.inSeconds;
                      player.seek(Duration(seconds: value.toInt()));
                    });
                    print(_controller!.value);
                  }
                ),
              ),
            ),
          ],
        ),
        AudioDuration()
      ],
    );
  }

  AudioDuration() {
    return Text('${duration.inSeconds-position.inSeconds} s',style: TextStyle(fontSize: 8,fontFamily: 'TEXT'),);
  }
}