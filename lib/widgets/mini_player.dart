import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';
import 'package:provider/provider.dart';

import '../providers/music_player_provider.dart';
import '../screens/PlayerScreen.dart';

class Mini_Player extends StatelessWidget {
  final List<Song> songs;
  final int currentIndex;

  static const String routeName = "Mini_Player";

  const Mini_Player({
    super.key,
    required this.songs,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final musicProvider = context.watch<MusicPlayerProvider>();

    final currentSong = musicProvider.currentSong;

    if (currentSong == null) {
      return const SizedBox();
    }

    final player = musicProvider.audioService.player;

    return StreamBuilder<Duration>(
      stream: player.onPositionChanged,
      initialData: Duration.zero,
      builder: (context, positionSnapshot) {
        final position = positionSnapshot.data ?? Duration.zero;

        return StreamBuilder<Duration?>(
          stream: player.onDurationChanged,
          initialData: null,
          builder: (context, durationSnapshot) {
            final duration = durationSnapshot.data;
            final maxDuration = duration?.inMilliseconds.toDouble() ?? 1.0;
            final currentPosition = position.inMilliseconds.toDouble().clamp(
              0.0,
              maxDuration,
            );

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerScreen(
                      songs: musicProvider.songs,
                      currentIndex: musicProvider.currentIndex,
                    ),
                  ),
                );
              },

              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(
                      value: maxDuration > 0
                          ? currentPosition / maxDuration
                          : 0,

                      minHeight: 3,

                      backgroundColor: Colors.grey,

                      valueColor: const AlwaysStoppedAnimation(
                        Colors.black,
                      ),
                    ),
                    // SizedBox(height: 5),
                    Row(
                      children: [
                        // Song Image
                        Container(
                          height: height * 0.06,
                          width: width * 0.15,
                          //color: Colors.amber,
                        ),

                        SizedBox(width: width * 0.03),

                        // Song Info
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentSong.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      currentSong.artist,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  SizedBox(width: width * 0.03),

                                  Text(currentSong.duration),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Previous
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),

                          onPressed: () {
                            musicProvider.previous();
                          },

                          icon: const Icon(Icons.skip_previous),
                        ),

                        // Play / Pause
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),

                          onPressed: () {
                            musicProvider.togglePlayPause();
                          },

                          icon: Icon(
                            musicProvider.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        ),

                        // Next
                        IconButton(
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
            );
          },
        );
      },
    );
  }
  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;

    final seconds = duration.inSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
