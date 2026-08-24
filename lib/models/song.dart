class Song {
  final String title;//اسم الاعنيه
  final String artist;//اسم الفنان.
  final String image;//صورة الأغنية.
  final String path;//مكان ملف الأغنية نفسه.
   String duration ;//مدة الأغنية.

  Song({
    required this.title,
    required this.artist,
    required this.image,
    required this.path,
    required this.duration,
  });
}
