import 'package:audio_fetcher/audio_item_model.dart';
import 'package:audio_fetcher/audio_query.dart';
import 'package:music_player/models/song.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioQueryService {
  final AudioQuery audioQuery = AudioQuery();

  Future<List<AudioItemModel>> getSongs() async {
    final status = await Permission.audio.request();

    if (!status.isGranted) {
      return [];
    }

    try {
      return await audioQuery.getAudios();
    } catch (e) {
      print('Error while getting songs: $e');
      return [];
    }
  }

  List<Song> convertToSongs(List<AudioItemModel> audioSongs) {
    return audioSongs.map((audio) {
      return Song(
        title: audio.title,
        artist: audio.artist ?? 'Unknown Artist',
        image: '',
        path: audio.path ?? '',
        duration: '0:00',
      );
    }).toList();
  }
}