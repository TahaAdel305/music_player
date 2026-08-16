import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';
class Song_Item extends StatelessWidget {
  final Song song;
  const Song_Item({super.key,
  required this.song,
  });
  @override
  Widget build(BuildContext context) {
    var hight = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
          padding: EdgeInsets.symmetric(horizontal: hight*0.01),
          child: Row(
            children: [
              Container(
                height: hight*0.07,
                width: width*0.15,
                color: Colors.amber,),
              SizedBox(width: width*0.03,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(song.title,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
                    Row(children: [
                      Text(song.artist
                        ,style: TextStyle(fontSize: 16),),
                      SizedBox(width: 10,),
                      Text(song.duration
                        ,style: TextStyle(fontSize: 16),),

                    ],)
                    ,],),
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.more_vert),)
            ],
          ),
        );
      //body: ,

  }
}
