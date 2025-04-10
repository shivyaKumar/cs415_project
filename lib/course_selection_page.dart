import 'package:cs415_project/models/course_model.dart';
import 'package:flutter/material.dart';
import '../services/local_storage.dart';
import '../models/program_level_model.dart';

class CourseSelectionPage extends StatefulWidget {
  final List<ProgramLevel> programLevels;
  const CourseSelectionPage({super.key, required this.programLevels});

  @override
  _CourseSelectionPageState createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  List<String> selectedCourses = [];

  /// Checks if a course can be selected based on prerequisites and selection limit
  bool canSelectCourse(Course course) {
    if (selectedCourses.length >= 4) return false;
    if (course.prerequisites.isEmpty) return true;
    return course.prerequisites.every((prereq) => selectedCourses.contains(prereq));
  }

  /// Toggles course selection on or off
  void toggleCourseSelection(String courseCode) {
    setState(() {
      if (selectedCourses.contains(courseCode)) {
        selectedCourses.remove(courseCode);
      } else if (selectedCourses.length < 4) {
        selectedCourses.add(courseCode);
      }
    });
  }

  /// Navigates to the Enrollment Page after selection
  void proceedToEnrollment() async {
    await LocalStorage.saveSelectedCourses(selectedCourses);
    Navigator.pushNamed(context, '/enrollment');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Course Selection")),
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
                children: widget.programLevels
                    .expand((level) => level.programs)
                    .expand((program) => program.years)
                    .expand((year) => year.courses)
                    .map((course) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: CheckboxListTile(
                      title: Text(
                        "${course.code} - ${course.name}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: course.prerequisites.isNotEmpty
                          ? Text(
                              "Prerequisites: ${course.prerequisites.join(', ')}",
                              style: const TextStyle(color: Colors.grey),
                            )
                          : null,
                      value: selectedCourses.contains(course.code),
                      onChanged: canSelectCourse(course)
                          ? (bool? value) => toggleCourseSelection(course.code)
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
          ],
        ),
      ),
    );
  }
}
