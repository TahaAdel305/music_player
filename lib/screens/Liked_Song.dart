import '../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_player_provider.dart';
import '../widgets/SongItem.dart';

class likedSong extends StatelessWidget {
  static const String routeName = "LikeSong";

  const likedSong({super.key});

  @override
  Widget build(BuildContext context) {
    final musicProvider = context.watch<MusicPlayerProvider>();

    final likedSongs = musicProvider.likedSongs;

    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.likedsongs),
        centerTitle: true,
      ),

      body: likedSongs.isEmpty
          ? const Center(
        child: Text(
          "No liked songs",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.separated(
        itemCount: likedSongs.length,

        itemBuilder: (context, index) {
          final song = likedSongs[index];
          final originalIndex =
          musicProvider.songs.indexOf(song);
          if (originalIndex == -1) {
            return const SizedBox();
          }

          return Song_Item(
            song: song,
            index: originalIndex,
          );
        },

        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}