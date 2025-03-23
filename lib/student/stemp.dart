import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/course_model.dart';
import '../models/program_level_model.dart';
import '../services/local_storage.dart';

class StempPage extends StatefulWidget {
  final List<ProgramLevel> programLevels;
  const StempPage({super.key, required this.programLevels});

  @override
  StempPageState createState() => StempPageState();
}

class StempPageState extends State<StempPage> {
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
          backgroundColor: Colors.transparent,
        ),
        
      ),
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
