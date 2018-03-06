import 'package:familog/domain/diary_entry_image.dart';

class DiaryEntry {
  const DiaryEntry(
      this.id,
      this.reaction,
      this.body,
      this.wroteAt,
      this.images
      );

  final int id;
  final String reaction;
  final String body;
  final DateTime wroteAt;
  final List<DiaryEntryImage> images;

  String title() {
    return "2017/01/20 すーさんの日記☻";
  }
}
