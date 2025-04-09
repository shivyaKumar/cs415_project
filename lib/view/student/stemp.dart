import 'package:flutter/material.dart';
import '/services/xml_parser.dart';
import '../../models/student/course_model.dart';
import '../../models/student/program_level_model.dart';
import '../../services/local_storage.dart';
import 'widgets/custom_header.dart';
import 'widgets/custom_footer.dart';

class StempPage extends StatefulWidget {
  final List<ProgramLevel> programLevels;
  const StempPage({super.key, required this.programLevels});

  @override
  StempPageState createState() => StempPageState();
}

class StempPageState extends State<StempPage> {
  List<String> selectedCourses = [];
  List<Course> courses = [];
  Map<String, List<String>> courseAvailability = {};

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  int getCourseYear(String courseCode) {
    if (courseCode.length >= 3) {
      final yearChar = courseCode[2]; // Get the third character
      final year = int.tryParse(yearChar); // Try to parse it as an integer
      return year ?? 0; // Return 0 if parsing fails
    }
    return 0; // Return 0 if the course code is invalid
  }

  Future<void> _loadCourses() async {
    try {
      final coursesList = await loadCourses('STEMP', 'courseTypes.xml');
      final prerequisites = await loadPrerequisites('STEMP', 'prerequisites.xml');
      final availability = await loadCourseAvailability('STEMP', 'courseAvailability.xml');

      setState(() {
        courseAvailability = availability;
        courses = coursesList.where((course) {
          final courseYear = getCourseYear(course.code);
          final availableSemesters = availability[course.code] ?? [];
          // Only include first-year courses and courses available in Semester 1 or Both
          return courseYear == 1 &&
              (availableSemesters.contains('Semester 1') || availableSemesters.contains('Both'));
        }).toList();
      });
    } catch (e) {
      print('Error loading XML files: $e');
    }
  }

  bool canSelectCourse(Course course) {
    if (course.type == "half") return true;
    if (selectedCourses.length >= 4) return false;
    if (course.prerequisites.isEmpty) return true;
    return course.prerequisites.every((prereq) => selectedCourses.contains(prereq));
  }

  void toggleCourseSelection(Course course) {
    setState(() {
      if (selectedCourses.contains(course.code)) {
        selectedCourses.remove(course.code);
      } else {
        selectedCourses.add(course.code);
      }
    });
  }

  void proceedToEnrollment() async {
  try {
    await LocalStorage.saveSelectedCourses(selectedCourses);
    Navigator.pushNamed(
      context,
      '/enrollment',
      arguments: selectedCourses.map((code) {
        final course = courses.firstWhere((c) => c.code == code);
        return {
          'code': course.code,
          'title': course.name,
          'campus': 'Laucala', // Default campus
        };
      }).toList(),
    );
  } catch (e) {
    print('Error saving file: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomHeader(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select up to 4 courses",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: courses.map((course) {
                  final availableSemesters = courseAvailability[course.code] ?? [];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: CheckboxListTile(
                      title: Text(
                        "${course.code} - ${course.name}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (course.prerequisites.isNotEmpty)
                            Text(
                              "Prerequisites: ${course.prerequisites.join(', ')}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          if (availableSemesters.isNotEmpty)
                            Text(
                              "Available in: ${availableSemesters.join(', ')}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          if (course.prerequisites.isEmpty && availableSemesters.isEmpty)
                            const Text(
                              "No prerequisites or availability info",
                              style: TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                      value: selectedCourses.contains(course.code),
                      onChanged: canSelectCourse(course)
                          ? (bool? value) => toggleCourseSelection(course)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedCourses.isNotEmpty ? proceedToEnrollment : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: const Center(child: Text("Proceed to Enrollment")),
            ),
            const SizedBox(height: 20),
            CustomFooter(screenWidth: screenWidth),
          ],
        ),
      ),
    );
  }
}