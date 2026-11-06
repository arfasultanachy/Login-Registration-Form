class Assessment {
  String id;
  String courseCode;
  String title;
  double marksObtained;
  double totalMarks;

  Assessment({
    required this.id,
    required this.courseCode,
    required this.title,
    required this.marksObtained,
    required this.totalMarks,
  });

  double get scorePercentage {
    if (totalMarks == 0) return 0.0;
    return (marksObtained / totalMarks) * 100;
  }
}
