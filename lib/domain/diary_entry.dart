import 'package:intl/intl.dart';


class DiaryEntry {
  const
  DiaryEntry(
      this.id,
      this.reaction,
      this.body,
      this.wroteAt,
      this.images
      );

  final String id;
  final String reaction;
  final String body;
  final DateTime wroteAt;
  final List<String> images;

  String title() {
    var formatter = new DateFormat('yyyy-MM-dd');
    return "${formatter.format(wroteAt)} すーさんの日記";
  }

  String primaryImageUrl() {
    if(images.isEmpty)
      return 'http://benesse.jp/kosodate/201709/img/KJ_20170908_02.jpg';
    return images.first;
  }
}
