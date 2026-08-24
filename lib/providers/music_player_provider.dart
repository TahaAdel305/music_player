import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/audio_service.dart';

class MusicPlayerProvider extends ChangeNotifier {
  final AudioService audioService = AudioService();

  List<Song> songs = [];
  List<Song> likedSongs=[];
  int currentIndex = 0;
  bool isPlaying = false;

  Song? get currentSong {
    if (songs.isEmpty) {
      return null;
    }

    return songs[currentIndex];
  }
  void toggleLike(Song song) {
    if (likedSongs.contains(song)) {
      likedSongs.remove(song);
    } else {
      likedSongs.add(song);
    }

    notifyListeners();
  }
  bool isLiked(Song song) {
    return likedSongs.contains(song);
  }
  void setSongs(List<Song> newSongs) {
    songs = newSongs;

    if (currentIndex >= songs.length) {
      currentIndex = 0;
    }

    notifyListeners();
  }
  void selectSong(int index) {
    if (index < 0 || index >= songs.length) {
      return;
    }

    currentIndex = index;
    isPlaying = false;
    notifyListeners();
  }
  Future<void> selectAndPlay(int index) async {
    if (index < 0 || index >= songs.length) {
      return;
    }

    currentIndex = index;

    await playCurrentSong();

    notifyListeners();
  }
  Future<void> playCurrentSong() async {
    final song = currentSong;

    if (song == null) {
      return;
    }

    await audioService.play(song.path);

    isPlaying = true;
    notifyListeners();
  }

  Future<void> pause() async {
    await audioService.pause();

    isPlaying = false;
    notifyListeners();
  }
  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await pause();
    } else {
      await audioService.resume();

      isPlaying = true;
      notifyListeners();
    }
  }

  Future<void> next() async {
    if (songs.isEmpty) {
      return;
    }

    if (currentIndex < songs.length - 1) {
      currentIndex++;
      await playCurrentSong();
      notifyListeners();
    }
  }

  Future<void> previous() async {
    if (songs.isEmpty) {
      return;
    }

    if (currentIndex > 0) {
      currentIndex--;
      await playCurrentSong();
      notifyListeners();
    }
  }

}