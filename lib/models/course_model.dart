class Course {
  final String code;
  final String name;
  final List<String> prerequisites;

  Course({required this.code, required this.name, this.prerequisites = const []});
}
