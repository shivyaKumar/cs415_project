class CourseAvailability {
  final String courseCode;
  final String semester;
  final bool offered;

  CourseAvailability({
    required this.courseCode,
    required this.semester,
    required this.offered,
  });

  // Factory method to create a CourseAvailability object from a map
  factory CourseAvailability.fromMap(Map<String, dynamic> map) {
    return CourseAvailability(
      courseCode: map['courseCode'] as String,
      semester: map['semester'] as String,
      offered: (map['offered'] as String).toLowerCase() == 'true',
    );
  }

  // Convert the CourseAvailability object to a map
  Map<String, dynamic> toMap() {
    return {
      'courseCode': courseCode,
      'semester': semester,
      'offered': offered.toString(),
    };
  }
}