class DiaryEntry {
  const DiaryEntry(
      this.id,
      this.title,
      this.body,
      this.wroteAt,
      );

  final String id;
  final String title;
  final String body;
  final DateTime wroteAt;
}