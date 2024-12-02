import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_test/models/song_model.dart';

class HomeViewModel extends ChangeNotifier {
  late SongModel song;
  late AudioPlayer player;
  bool isPlay = false;
  Duration? totalDuration = const Duration();

  Future<void> onInit() async {
    song = SongModel(
      nameSong: 'Về đâu mái tóc người thương',
      singer: 'Quang Lê',
      url: 'https://storage.googleapis.com/ikara-storage/tmp/beat.mp3',
      urlLyrics: 'urlLyrics',
    );

    player = AudioPlayer()..setSourceUrl(song.url);
  }

  void onPlay() {
    if (player.state == PlayerState.stopped || player.state == PlayerState.completed) {
      player.play(UrlSource(song.url));
    } else if (player.state == PlayerState.playing) {
      player.pause();
    } else if (player.state == PlayerState.paused) {
      player.resume();
    }
  }

  void onSeek(double value) {
    if (player.state == PlayerState.completed) {
      player.play(UrlSource(song.url));
    }
    player.seek(Duration(seconds: value.toInt()));
  }
}
