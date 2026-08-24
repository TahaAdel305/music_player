import 'package:flutter/material.dart';
import 'package:music_player/widgets/SongItem.dart';
import 'package:music_player/widgets/mini_player.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/song.dart';
import '../providers/language_provider.dart';
import '../providers/music_player_provider.dart';
import '../providers/theme_provider.dart';
import '../services/audio_fetcher_service.dart';
import '../widgets/list_tile.dart';
import 'package:audioplayers/audioplayers.dart';
import 'Liked_Song.dart';
class HomeScreen extends StatefulWidget {
  static const String routeName = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Widget buildSkeletonItem(double height, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: height * 0.01,
        vertical: 8,
      ),
      child: Row(
        children: [
          Container(
            height: height * 0.07,
            width: width * 0.15,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          SizedBox(width: width * 0.03),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: width * 0.50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  height: 12,
                  width: width * 0.30,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 12,
            width: 35,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
  List<Song> songs = [];
  bool isLoading = true;
  final AudioPlayer durationPlayer = AudioPlayer();
  @override
  void dispose() {
    durationPlayer.dispose();
    super.dispose();
  }
  String formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  //int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    final service = AudioQueryService();

    final audioSongs = await service.getSongs();

    if (!mounted) return;

    // نبدأ الفحص، لكن القائمة الحقيقية لسه فاضية
    setState(() {
      songs = [];
      isLoading = true;
    });

    await loadDurations(
      service.convertToSongs(audioSongs),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadDurations(List<Song> allSongs) async {
    for (final song in allSongs) {
      if (song.path.isEmpty) {
        continue;
      }

      try {
        await durationPlayer.setSource(
          DeviceFileSource(song.path),
        );

        final duration = await durationPlayer.getDuration();

        if (duration == null) {
          continue;
        }

        final seconds = duration.inSeconds;

        // أقل من 30 ثانية → تجاهلها تمامًا
        if (seconds < 30) {
          continue;
        }

        // الأغنية مقبولة
        song.duration = formatDuration(
          duration.inMilliseconds,
        );

        if (!mounted) return;

        setState(() {
          songs.add(song);
        });

        // تحديث الـ Provider فورًا
        context.read<MusicPlayerProvider>().setSongs(
          List<Song>.from(songs),
        );
      } catch (e) {
        print('Error getting duration: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var hight = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final musicProvider = context.watch<MusicPlayerProvider>();
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.language),
              leading: Icon(Icons.language),
              children: [
                ListTile(
                  title: Text(AppLocalizations.of(context)!.arabic),
                  onTap: () {
                    context.read<AppLanguageProvider>().changeLanguage('ar');
                  },
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.english),
                  onTap: () {
                    context.read<AppLanguageProvider>().changeLanguage('en');
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.theme),
              leading: Icon(Icons.dark_mode_outlined),
              children: [
                ListTile(
                  title: Text(AppLocalizations.of(context)!.day),
                  onTap: () {
                    context.read<ThemeProvider>().changeTheme(ThemeMode.dark);
                  },
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.night),
                  onTap: () {
                    context.read<ThemeProvider>().changeTheme(ThemeMode.light);
                  },
                ),
              ],
            ),
            InkWell(
              onTap: (){
                Navigator.pushNamed(
                    context,
                    likedSong.routeName
                );
              },
              child: CustomListTile(
                title: (AppLocalizations.of(context)!.liked),
                leading: Icon(Icons.favorite_border),
              ),
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
                        Text(
                          AppLocalizations.of(context)!.recommended,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                    ],
                  ),
                ),

                SizedBox(height: hight * 0.01),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            if (index < songs.length) {
                              return Song_Item(
                                song: songs[index],
                                index: index,
                              );
                            }
                            return buildSkeletonItem(
                              hight,
                              width,
                            );
                          },

                          separatorBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 37,
                              ),
                              child: Divider(),
                            );
                          },
                          itemCount: isLoading
                              ? songs.length + 5
                              : songs.length,
                        ),
                      ),

                      if (songs.isNotEmpty)
                        Mini_Player(
                          songs: songs,
                          currentIndex: musicProvider.currentIndex,
                        ),

                      SizedBox(height: hight * 0.01),
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
