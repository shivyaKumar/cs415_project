class Course {
  final String code;
  final String name;
  final String type;
  final List<String> prerequisites;

  Course({
    required this.code, 
    required this.name, 
    required this.prerequisites, 
    required this.type
    });
}
