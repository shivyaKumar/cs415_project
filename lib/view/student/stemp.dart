import 'package:flutter/material.dart';
import '../../models/student/course_model.dart';
import '../../models/student/program_level_model.dart';
import '../../services/local_storage.dart';
import '../../xml_loader.dart'; // Updated to use xml_loader
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
  List<Map<String, dynamic>> courses = [];
  Map<String, dynamic> courseAvailability = {};

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
      // Load data using XmlUploader
      final semTypeData = await XmlUploader.parseSemTypes();
      final availability = await XmlUploader.parseCourseAvailability(semTypeData);
      final prerequisites = await XmlUploader.parsePrerequisites();
      final coursesList = await XmlUploader.parseCourses(availability, prerequisites);

      final stemPrefixes = ['CS', 'IS', 'MA', 'PH', 'ST', 'UU'];

      setState(() {
        courseAvailability = availability;
        courses = coursesList.values
            .where((course) {
              final courseCode = course['code'] ?? '';
              final prefix = courseCode.length >= 2 ? courseCode.substring(0, 2) : '';
              final courseYear = getCourseYear(courseCode);
              final availableSemesters = availability[course['course_availability_id']]?['semester'] ?? [];

              return stemPrefixes.contains(prefix) &&
                  courseYear == 1 &&
                  (availableSemesters.contains('Semester 1') || availableSemesters.contains('Both'));
            })
            .cast<Map<String, dynamic>>()
            .toList();
      });
    } catch (e) {
      print('Error loading XML files: $e');
    }
  }


  bool canSelectCourse(Map<String, dynamic> course) {
    if (course['type'] == "half") return true;
    if (selectedCourses.length >= 4) return false;
    if (course['prerequisites'] == null || course['prerequisites'].isEmpty) return true;
    return course['prerequisites'].every((prereq) => selectedCourses.contains(prereq));
  }

  void toggleCourseSelection(Map<String, dynamic> course) {
    setState(() {
      if (selectedCourses.contains(course['code'])) {
        selectedCourses.remove(course['code']);
      } else {
        selectedCourses.add(course['code']);
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
          final course = courses.firstWhere((c) => c['code'] == code);
          return {
            'code': course['code'],
            'title': course['name'],
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
                  final availableSemesters = courseAvailability[course['course_availability_id']]?['semester'] ?? [];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: CheckboxListTile(
                      title: Text(
                        "${course['code']} - ${course['name']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (course['prerequisites'] != null && course['prerequisites'].isNotEmpty)
                            Text(
                              "Prerequisites: ${(course['prerequisites'] ?? []).join(', ')}", // Ensure non-null
                              style: const TextStyle(color: Colors.grey),
                            ),
                          if (availableSemesters.isNotEmpty)
                            Text(
                              "Available in: ${((availableSemesters is List ? availableSemesters : [availableSemesters]) ?? []).join(', ')}", // Ensure non-null
                              style: const TextStyle(color: Colors.grey),
                            ),
                          if ((course['prerequisites'] == null || course['prerequisites'].isEmpty) &&
                              availableSemesters.isEmpty)
                            const Text(
                              "No prerequisites or availability info",
                              style: TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                      value: selectedCourses.contains(course['code']),
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