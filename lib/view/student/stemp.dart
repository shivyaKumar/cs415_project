import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '/services/xml_parser.dart';
import '../../models/course_model.dart';
import '../../models/program_level_model.dart';
import '../../services/local_storage.dart';
import 'package:file_saver/file_saver.dart'; // Import the file_saver package
import 'dart:typed_data';
import '/global.dart';

class StempPage extends StatefulWidget {
  final List<ProgramLevel> programLevels;
  const StempPage({super.key, required this.programLevels});

  @override
  StempPageState createState() => StempPageState();
}

class StempPageState extends State<StempPage> {
  List<String> selectedCourses = [];
  List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      // Load courses
      final coursesList = await loadCourses('assets/STEMP/courses.xml');

      // Load prerequisites
      final prerequisites = await loadPrerequisites('assets/STEMP/prerequisites.xml');

      // Load program levels
      final programLevels = await loadProgramLevels('assets/STEMP/programLevels.xml');

      // Load programs
      final programs = await loadPrograms('assets/STEMP/programs.xml');

      // Load program types
      final programTypes = await loadProgramTypes('assets/STEMP/programTypes.xml');

      // Load semesters
      final semesters = await loadSemesters('assets/STEMP/semesters.xml');

      // Load sub-programs
      final subPrograms = await loadSubPrograms('assets/STEMP/subPrograms.xml');

      // Combine or process the data as needed
      setState(() {
        courses = coursesList;
        // You can process and store other data here if needed
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
      } else{
        selectedCourses.add(course.code);
      }
    });
  }

  void proceedToEnrollment() async {
    try {
      final email = loggedInEmails.isNotEmpty ? loggedInEmails.last : 'Unknown';

      await LocalStorage.saveSelectedCourses(selectedCourses);

      //format of date and time
      final now = DateTime.now();
      final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      
      final courseList = selectedCourses.join('\n');
      final fileContent = '''
        Created by: $email
        Date and Time: $formattedDateTime

        Selected Courses:
        $courseList
        ''';
      final bytes = Uint8List.fromList(fileContent.codeUnits);

      // Save the file using FileSaver
      await FileSaver.instance.saveFile(
        name: "selected_courses",
        bytes: bytes,
        ext: "txt",
        mimeType: MimeType.text,
      );
      Navigator.pushNamed(context, '/enrollment', arguments: selectedCourses);
    } catch (e) {
      // Handle any errors
      print('Error saving file: $e');
    }
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
                children: courses.map((course) {
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
                          : const Text(
                              "No prerequisites",
                              style: TextStyle(color: Colors.grey),
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