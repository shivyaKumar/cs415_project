import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/student/course_model.dart';
import '../../models/student/program_level_model.dart';
import '../../services/local_storage.dart';

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: AppBar(
          flexibleSpace: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/header.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          ),
        ),
        backgroundColor: Colors.transparent,
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
            const SizedBox(height: 20),
            _buildFooter(),
          ],
        ),
      ),
    );
  }
}

Widget _buildFooter({double height = 80}) {
    return SizedBox(
      height: height,
      child: Container(
        width: double.infinity,
        color: Colors.teal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _openLink('https://www.example.com/copyright'),
                        child: const Text(
                          'Copyright',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('|', style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => _openLink('https://www.example.com/contact'),
                        child: const Text(
                          'Contact Us',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '© Copyright 1968 - 2025. All Rights Reserved.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/usp_logo.svg',
                  width: 133,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text('The University of the South Pacific', style: TextStyle(color: Colors.white)),
                  Text('Laucala Campus, Suva, Fiji', style: TextStyle(color: Colors.white)),
                  Text('Tel: +679 323 1000', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openLink(String url) {
    print('Opening link: $url');
  }
