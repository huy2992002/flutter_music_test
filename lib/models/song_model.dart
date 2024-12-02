import 'package:flutter_music_test/models/lyric_model.dart';

class SongModel {
  String nameSong;
  String singer;
  String url;
  List<LyricModel> lyrics;

  SongModel({
    required this.nameSong,
    required this.singer,
    required this.url,
    required this.lyrics,
  });
}
