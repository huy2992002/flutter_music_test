import 'package:flutter_music_test/models/lyric_item_model.dart';

class LyricModel {
  List<LyricItemModel> lyrics;

  LyricModel({required this.lyrics});

  double? get timeStart => lyrics.firstOrNull?.time;
  double? get timeEnd => lyrics.lastOrNull?.time;
}
