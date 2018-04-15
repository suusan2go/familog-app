import 'package:familog/domain/diary_entry_author.dart';
import 'package:intl/intl.dart';


class DiaryEntry {
  const
  DiaryEntry(
      this.id,
      this.reaction,
      this.body,
      this.wroteAt,
      this.images,
      this.author
      );

  final String id;
  final String reaction;
  final String body;
  final DateTime wroteAt;
  final List<String> images;
  final DiaryEntryAuthor author;

  String title() {
    var formatter = new DateFormat('yyyy-MM-dd');
    return "${formatter.format(wroteAt)} ${author.name}の日記";
  }

  String primaryImageUrl() {
    if(images.isEmpty)
      return 'http://benesse.jp/kosodate/201709/img/KJ_20170908_02.jpg';
    return images.first;
  }
}
