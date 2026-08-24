import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';
import 'package:provider/provider.dart';

import '../providers/music_player_provider.dart';
import '../screens/PlayerScreen.dart';
class Song_Item extends StatelessWidget {
  final Song song;
  final int index;
  const Song_Item({super.key, required this.song,required this.index});

  @override
  Widget build(BuildContext context) {
    var hight = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () async {
        final musicProvider = context.read<MusicPlayerProvider>();

        if (musicProvider.currentIndex == index) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerScreen(
                songs: musicProvider.songs,
                currentIndex: musicProvider.currentIndex,
              ),
            ),
          );
        } else {
          await musicProvider.selectAndPlay(index);
        }
      },

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: hight * 0.01),
        child: Row(
          children: [
            Container(
              height: hight * 0.07,
              width: width * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(File(song.image)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          song.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),

                      SizedBox(width: 10),

                      Text(
                        song.duration,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
          ],
        ),
      ),
    );
    //body: ,
  }
}
