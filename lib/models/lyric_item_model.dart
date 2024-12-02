import 'package:xml/xml.dart';

class LyricItemModel {
  double time;
  String text;
  bool isPlayed;

  LyricItemModel({
    required this.time,
    required this.text,
    this.isPlayed = false,
  });

  factory LyricItemModel.fromXmlElement(XmlElement element) {
    return LyricItemModel(
      time: double.parse(element.getAttribute('va') ?? '0.0'),
      text: element.innerText,
    );
  }
}
