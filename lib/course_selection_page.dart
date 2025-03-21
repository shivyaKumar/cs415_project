import 'package:cs415_project/models/course_model.dart';
import 'package:flutter/material.dart';
import '../services/local_storage.dart';
import '../models/program_level_model.dart';

class CourseSelectionPage extends StatefulWidget {
  final List<ProgramLevel> programLevels;
  CourseSelectionPage({required this.programLevels});

  @override
  _CourseSelectionPageState createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  List<String> selectedCourses = [];

  bool canSelectCourse(Course course) {
    if (selectedCourses.length >= 4) return false;
    if (course.prerequisites.isEmpty) return true;
    return course.prerequisites.every((prereq) => selectedCourses.contains(prereq));
  }

  void toggleCourseSelection(String courseCode) {
    setState(() {
      if (selectedCourses.contains(courseCode)) {
        selectedCourses.remove(courseCode);
      } else if (selectedCourses.length < 4) {
        selectedCourses.add(courseCode);
      }
    });
  }

  void proceedToEnrollment() async {
    await LocalStorage.saveSelectedCourses(selectedCourses);
    Navigator.pushNamed(context, '/enrollment');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Courses")),
      body: ListView(
        children: widget.programLevels.expand((level) => level.programs).expand((program) => program.years).expand((year) => year.courses).map((course) {
          return CheckboxListTile(
            title: Text("${course.code} - ${course.name}"),
            subtitle: course.prerequisites.isNotEmpty
                ? Text("Prerequisites: ${course.prerequisites.join(', ')}")
                : null,
            value: selectedCourses.contains(course.code),
            onChanged: canSelectCourse(course) ? (bool? value) => toggleCourseSelection(course.code) : null,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectedCourses.isNotEmpty ? proceedToEnrollment : null,
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
