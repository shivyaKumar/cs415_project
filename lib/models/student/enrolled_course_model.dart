class EnrolledCourse {
  final String code;
  final String title;
  final String campus;
  final String mode;
  final String status;

  EnrolledCourse({
    required this.code,
    required this.title,
    required this.campus,
    required this.mode,
    this.status = "Registered",
  });
}
