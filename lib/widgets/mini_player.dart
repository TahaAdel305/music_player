import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/theme/app_color.dart';
import 'package:music_player/models/song.dart';

class Mini_Player extends StatefulWidget {
  final Song song;
  static const String routeName = "Mini_Player";

  const Mini_Player({super.key, required this.song});
  @override
  State<Mini_Player> createState() => _Mini_PlayerState();
}
class _Mini_PlayerState extends State<Mini_Player> {
  bool IsPlaying = false;
  @override
  Widget build(BuildContext context) {
    var hight = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        child: Row(
          children: [
            Container(
              height: hight * 0.07,
              width: width * 0.15,
              color: Colors.amber,
            ),
            SizedBox(width: width*0.04,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.song.title),
                    Row(children: [
                      Text(widget.song.artist),
                      SizedBox(width: width*0.03,),
                      Text(widget.song.duration)
                    ],)

                  ]),
            ),
            Expanded(child: SizedBox(width: width*0.04,)),

            IconButton(onPressed: () {}, icon: Icon(Icons.skip_previous)),

            IconButton(onPressed: () {setState(() {
              IsPlaying=!IsPlaying;
            });}, icon: Icon(IsPlaying?Icons.pause:Icons.play_arrow)),
            //Icons.play_arrow_outlined
            IconButton(onPressed: () {}, icon: Icon(Icons.skip_next)),
            //SizedBox(width: width*0.04,)
          ],
        ),
      ),
    );
  }
}
