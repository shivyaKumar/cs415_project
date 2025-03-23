import 'package:flutter/material.dart';
import '../models/program_level_model.dart';
import '../models/course_model.dart';
import '../services/local_storage.dart';

class SageonsPage extends StatefulWidget {
  final List<ProgramLevel> programLevels;

  const SageonsPage({super.key, required this.programLevels});

  @override
  SageonsPageState createState() => SageonsPageState();
}

class SageonsPageState extends State<SageonsPage> {
  List<String> selectedCourses = [];

  /// Helper to flatten all available courses
  List<Course> get allCourses => widget.programLevels
      .expand((level) => level.programs)
      .expand((program) => program.years)
      .expand((year) => year.courses)
      .toList();

  /// Checks if a course can be selected based on prerequisites and selection limit
  bool canSelectCourse(Course course) {
    print("Checking if course can be selected: ${course.code}");

    if (selectedCourses.length >= 4) {
      print("Max course limit reached");
      return false;  // Cannot select more than 4 courses
    }

    if (course.prerequisites.isEmpty) {
      print("No prerequisites for ${course.code}");
      return true;  // If no prerequisites, the course is always selectable
    }

    // Check prerequisites
    bool canSelect = course.prerequisites.every((prereq) => selectedCourses.contains(prereq));
    if (!canSelect) {
      print("Prerequisites not met for ${course.code}");
    }

    return canSelect;
  }


  /// Toggles course selection on or off, and auto-deselects dependent courses if needed
  void toggleCourseSelection(String courseCode) {
    setState(() {
      if (selectedCourses.contains(courseCode)) {
        selectedCourses.remove(courseCode);

        // Auto-deselect dependent courses
        final toRemove = _findDependentCourses(courseCode);
        selectedCourses.removeWhere((code) => toRemove.contains(code));
      } else {
        final course = allCourses.firstWhere((c) => c.code == courseCode);

        if (!canSelectCourse(course)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Cannot select ${course.code}. Either prerequisites not met or max 4 courses allowed.",
              ),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 3),
            ),
          );
          return;
        }

        selectedCourses.add(courseCode);
      }
    });
  }

  /// Recursively finds all selected courses that depend on a course
  Set<String> _findDependentCourses(String removedCode) {
    Set<String> dependents = {};

    bool hasDependency(Course course) =>
        course.prerequisites.contains(removedCode) ||
        course.prerequisites.any((prereq) => dependents.contains(prereq));

    bool found;
    do {
      found = false;
      for (var course in allCourses) {
        if (selectedCourses.contains(course.code) &&
            !dependents.contains(course.code) &&
            hasDependency(course)) {
          dependents.add(course.code);
          found = true;
        }
      }
    } while (found);

    return dependents;
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
                children: allCourses.map((course) {
                  final isSelected = selectedCourses.contains(course.code);
                  final canSelect = canSelectCourse(course);
                  final isEnabled = selectedCourses.length < 4 || isSelected;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    color: !isEnabled ? Colors.grey[200] : null, // Grey out when disabled
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
                      value: isSelected,
                      onChanged: isEnabled
                          ? (bool? value) {
                              toggleCourseSelection(course.code);
                            }
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
