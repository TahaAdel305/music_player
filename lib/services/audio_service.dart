import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer player = AudioPlayer();

  Future<void> play(String path) async {
    await player.stop();
    await player.play(DeviceFileSource(path));
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> resume() async {
    await player.resume();
  }

  Future<void> stop() async {
    await player.stop();
  }

  void dispose() {
    player.dispose();
  }
}
