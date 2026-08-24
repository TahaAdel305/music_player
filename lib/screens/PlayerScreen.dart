import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../providers/music_player_provider.dart';

class PlayerScreen extends StatefulWidget {
  final List<Song> songs;
  final int currentIndex;

  const PlayerScreen({
    super.key,
    required this.songs,
    required this.currentIndex,
  });

  static const String routename = "PlayerScreen";

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  @override
  void initState() {
    super.initState();

    final player = context.read<MusicPlayerProvider>().audioService.player;

    player.onPositionChanged.listen((position) {
      if (!mounted) return;

      setState(() {
        currentPosition = position;
      });
    });

    player.onDurationChanged.listen((duration) {
      if (!mounted) return;

      setState(() {
        totalDuration = duration;
      });
    });

    loadCurrentPosition();
  }

  Future<void> loadCurrentPosition() async {
    final player = context.read<MusicPlayerProvider>().audioService.player;

    final duration = await player.getDuration();
    final position = await player.getCurrentPosition();

    if (!mounted) return;

    setState(() {
      totalDuration = duration ?? Duration.zero;
      currentPosition = position ?? Duration.zero;
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int number) {
      return number.toString().padLeft(2, '0');
    }

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    return '$minutes:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    var hight = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final musicProvider = context.watch<MusicPlayerProvider>();
    final currentSong = musicProvider.currentSong;

    if (currentSong == null) {
      return const Scaffold(body: Center(child: Text("No song selected")));
    }

    final maxDuration = totalDuration.inMilliseconds.toDouble();
    final currentValue = currentPosition.inMilliseconds.toDouble().clamp(
      0.0,
      maxDuration > 0 ? maxDuration : 1.0,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Playing Now"),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),

        child: Align(
          alignment: Alignment.topCenter,

          child: Column(
            children: [
              Container(height: 277, width: 255, color: Colors.blue),

              SizedBox(height: hight * 0.03),

              Text(
                currentSong.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: hight * 0.01),

              Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      currentSong.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        musicProvider.toggleLike(currentSong);
                        //Navigator.pop(context);
                      },
                      icon:  musicProvider.isLiked(currentSong)
                          ? Icon(Icons.favorite)
                          :Icon(Icons.favorite_border)
                    ),
                  ),
                ],
              ),

              SizedBox(height: hight * 0.10),
              Slider(
                inactiveColor: Colors.white70,
                min: 0,
                max: maxDuration > 0 ? maxDuration : 1,
                value: currentValue,
                onChanged: maxDuration > 0
                    ? (value) {
                        setState(() {
                          currentPosition = Duration(
                            milliseconds: value.toInt(),
                          );
                        });
                      }
                    : null,
                onChangeEnd: maxDuration > 0
                    ? (value) async {
                        await musicProvider.audioService.player.seek(
                          Duration(milliseconds: value.toInt()),
                        );
                      }
                    : null,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatDuration(currentPosition)),
                    Text(formatDuration(totalDuration)),
                  ],
                ),
              ),

              SizedBox(height: hight * 0.08),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Previous
                  IconButton(
                    iconSize: width * 0.10,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      musicProvider.previous();
                    },
                    icon: const Icon(Icons.skip_previous),
                  ),

                  SizedBox(width: width * 0.03),

                  // Play / Pause
                  IconButton(
                    iconSize: width * 0.10,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      musicProvider.togglePlayPause();
                    },
                    icon: Icon(
                      musicProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                  ),

                  SizedBox(width: width * 0.03),

                  // Next
                  IconButton(
                    iconSize: width * 0.10,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      musicProvider.next();
                    },
                    icon: const Icon(Icons.skip_next),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
