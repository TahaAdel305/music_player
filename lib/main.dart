import 'package:flutter/material.dart';
import 'package:music_player/providers/language_provider.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:music_player/screens/Liked_Song.dart';
import 'package:music_player/screens/PlayerScreen.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:music_player/screens/splash_screen.dart';
import 'package:music_player/services/audio_fetcher_service.dart';
import 'package:music_player/theme/app_color.dart';
import 'package:music_player/theme/app_theme.dart';
import 'package:music_player/widgets/mini_player.dart';
import 'package:provider/provider.dart';
import 'package:music_player/providers/music_player_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final audioService = AudioQueryService();

  final songs = await audioService.getSongs();

  /*print('Number of songs: ${songs.length}');

  for (final song in songs.take(5)) {
    print('Title: ${song.title}');
    print('Artist: ${song.artist}');
    print('Duration: ${song.duration}');
    print('-------------------');
  }
*/
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
        ChangeNotifierProvider(create: (_) => MusicPlayerProvider()),
      ],
      child: MusicPlayerApp(),
    ),
  );
}

class MusicPlayerApp extends StatelessWidget {
  //constMusicPlayerApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<AppLanguageProvider>(context);
    return MaterialApp(
      locale: languageProvider.appLanguage,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      //
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        likedSong.routeName: (context) => likedSong(),
      },
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      //themeMode: ThemeMode.dark,
      themeMode: themeProvider.appTheme,
    );
  }
}
