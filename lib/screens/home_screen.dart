import 'package:flutter/material.dart';
import 'package:music_player/widgets/SongItem.dart';
import 'package:music_player/widgets/mini_player.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/song.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/list_tile.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "HomeScreen";

  @override
  Widget build(BuildContext context) {
    var hight = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final song = Song(
        title: "Chaff & Dust",
        artist: "HYONNA",
        image: "",
        path: "",
        duration: "3.23");
    return Scaffold(
      //
      //appBar: AppBar(backgroundColor: Colors.transparent,),
      drawer: Drawer(
        child: ListView(
          children: [
            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.language),
              leading: Icon(Icons.language),
              children: [
                ListTile(title: Text(AppLocalizations.of(context)!.arabic),onTap: (){
                  context.read<AppLanguageProvider>().changeLanguage('ar');
                },
                ),
                ListTile(title: Text(AppLocalizations.of(context)!.english),onTap: (){
                  context.read<AppLanguageProvider>().changeLanguage('en');
                },),
              ],
            ),
            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.theme),
              leading: Icon(Icons.dark_mode_outlined),
              children: [
                ListTile(title: Text(AppLocalizations.of(context)!.day),onTap: (){
                  context.read<ThemeProvider>().changeTheme(
                      ThemeMode.dark,);
                },),
                ListTile(title: Text(AppLocalizations.of(context)!.night),onTap: (){
                  context.read<ThemeProvider>().changeTheme(
                      ThemeMode.light,);
                },),
              ],
            ),
            CustomListTile(
              title: (AppLocalizations.of(context)!.liked),
              leading: Icon(Icons.favorite_border),
            ),
            CustomListTile(
              title: (AppLocalizations.of(context)!.profile),
              leading: Icon(Icons.person),
            ),
            CustomListTile(
              title: (AppLocalizations.of(context)!.setting),
              leading: Icon(Icons.settings),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: width * 0.04,
                    vertical: hight * 0.01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                    ],
                  ),
                ),
                  Text(AppLocalizations.of(context)!.recommended,
                    style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,),),
                  SizedBox(height: hight*0.01,),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          //flex: 7,
                               child: ListView.separated(
                                   itemBuilder: (context,index){
                                     return Song_Item(song: song,);
                                   },
                                   separatorBuilder: (context,index){
                                     return Padding(
                                       padding: EdgeInsets.symmetric(horizontal: 37),
                                       child: Divider(),
                                     );
                                   },
                                   itemCount: 20),
                             ),
                        Mini_Player(
                          song: song,
                        ),
                        SizedBox(height: hight*0.01,)
                      ],
                    ),
                  ),


              ],
            );
          },
        ),
      ),
    );
  }
}
