import 'package:familog/domain/diary_entry.dart';
import 'package:familog/domain/diary_entry_image.dart';

class DiaryEntryRepository {
  // ダミー実装
  List<DiaryEntry> findAll() {
    return [
      new DiaryEntry(
        1,
        "今日はほげほげほげ",
        ":smile:",
        new DateTime.now(),
          [
            new DiaryEntryImage(1, 'http://benesse.jp/kosodate/201709/img/KJ_20170908_02.jpg'),
            new DiaryEntryImage(1, 'http://benesse.jp/kosodate/201709/img/KJ_20170908_02.jpg'),
        ]
      ),
      new DiaryEntry(
          1,
          "今日はほげほげほげ2\nほげほげ\nほげほげ",
          ":smile:",
          new DateTime.now(),
          [
            new DiaryEntryImage(1, 'http://benesse.jp/kosodate/201709/img/KJ_20170908_02.jpg'),
            new DiaryEntryImage(1, 'http://benesse.jp/kosodate/201709/img/KJ_20170908_02.jpg'),
          ]
      )
    ];
  }

  // ダミー実装
  DiaryEntry findByID(int id) {
    return new DiaryEntry(
        1,
        "今日はほげほげほげ",
        ":smile:",
        new DateTime.now(),
        [
          new DiaryEntryImage(1, 'http://benesse.jp/kosodate/201709/img/KJ_20170908_02.jpg'),
          new DiaryEntryImage(1, 'http://benesse.jp/kosodate/201709/img/KJ_20170908_02.jpg'),
        ]
    );
  }
}