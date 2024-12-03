import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_music_test/models/lyric_item_model.dart';
import 'package:flutter_music_test/models/lyric_model.dart';
import 'package:flutter_music_test/models/song_model.dart';
import 'package:xml/xml.dart';

class HomeViewModel extends ChangeNotifier {
  ViewState viewState = ViewState.init;
  AudioPlayer player = AudioPlayer();
  late SongModel song;

  LyricModel lyricModel = LyricModel(lyrics: []);
  int lyricIndex = 0;

  Future<void> onInit() async {
    setViewState(ViewState.loading);
    await fetchSong();
    listenerPlayerDuration();
    setViewState(ViewState.success);
  }

  Future<void> fetchSong() async {
    final lyrics = await fetchLyrics('assets/lyrics/lyric.xml');
    song = SongModel(
      nameSong: 'Về đâu mái tóc người thương',
      singer: 'Quang Lê',
      url: 'audios/audio_beat.mp3',
      lyrics: lyrics,
    );
  }

  void listenerPlayerDuration() {
    final lyrics = song.lyrics;
    lyricModel = song.lyrics.first;
    player.onPositionChanged.listen(
      (event) {
        double seconds = event.inMilliseconds / 1000;
        if (lyrics.first.timeStart != null &&
            seconds < lyrics.first.timeStart!) {
          lyricIndex = 0;
          lyricModel = lyrics[0];
        }
        for (int i = 0; i < song.lyrics.length; i++) {
          if (lyrics[i].timeStart != null &&
              lyrics[i].timeEnd != null &&
              lyrics[i].timeStart!.toInt() < seconds &&
              lyrics[i].timeEnd!.toInt() > seconds) {
            lyricIndex = i;
            lyricModel = lyrics[i];
          }
          notifyListeners();
        }
      },
    );
  }

  void setViewState(ViewState state) {
    viewState = state;
    notifyListeners();
  }

  Future<List<LyricModel>> fetchLyrics(String urlLyrics) async {
    final lyrics = <LyricModel>[];
    String xmlString = await rootBundle.loadString(urlLyrics);
    final xml = XmlDocument.parse(xmlString);
    for (final param in xml.findAllElements('param')) {
      final lyricItems = <LyricItemModel>[];
      for (final i in param.findAllElements('i')) {
        lyricItems.add(LyricItemModel.fromXmlElement(i));
      }
      lyrics.add(LyricModel(lyrics: lyricItems));
    }
    return lyrics;
  }

  void onPlay() {
    if (player.state == PlayerState.stopped ||
        player.state == PlayerState.completed) {
      player.play(AssetSource(song.url));
    } else if (player.state == PlayerState.playing) {
      player.pause();
    } else if (player.state == PlayerState.paused) {
      player.resume();
    }
  }

  void onSeek(double value) {
    if (player.state == PlayerState.completed) {
      player.play(AssetSource(song.url));
    }
    player.seek(Duration(seconds: value.toInt()));
  }

  void onDispose() {
    player.dispose();
  }
}

enum ViewState {
  init,
  loading,
  success,
}
