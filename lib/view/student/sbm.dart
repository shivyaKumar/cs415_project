import 'package:flutter/material.dart';
import '../../models/student/program_level_model.dart';
import '../../services/local_storage.dart';
import '../../xml_loader.dart';
import 'widgets/custom_header.dart';
import 'widgets/custom_footer.dart';

class SbmPage extends StatefulWidget {
  final List<ProgramLevel> programLevels;
  const SbmPage({super.key, required this.programLevels});

  @override
  State<SbmPage> createState() => _SbmPageState();
}

class _SbmPageState extends State<SbmPage> {
  List<String> selectedCourses = [];
  List<Map<String, dynamic>> courses = [];
  Map<String, dynamic> courseAvailability = {};

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  int getCourseYear(String code) => (code.length >= 3) ? int.tryParse(code[2]) ?? 0 : 0;

  Future<void> _loadCourses() async {
    final semTypeData = await XmlUploader.parseSemTypes();
    final availability = await XmlUploader.parseCourseAvailability(semTypeData);
    final prerequisites = await XmlUploader.parsePrerequisites();
    final allCourses = await XmlUploader.parseCourses(availability, prerequisites);

    final sbmPrefixes = ['MG', 'AF', 'EC'];

    setState(() {
      courseAvailability = availability;
      courses = allCourses.values
          .where((course) {
            final prefix = course['code'].substring(0, 2).toUpperCase();
            final year = getCourseYear(course['code']);
            final sem = availability[course['course_availability_id']]?['semester'] ?? [];
            return sbmPrefixes.contains(prefix) && year == 1 && (sem.contains('Semester 1') || sem.contains('Both'));
          })
          .cast<Map<String, dynamic>>()
          .toList();
    });
  }

  void toggleCourseSelection(Map<String, dynamic> course) {
    setState(() {
      selectedCourses.contains(course['code']) ? selectedCourses.remove(course['code']) : selectedCourses.add(course['code']);
    });
  }

  void proceedToEnrollment() async {
    await LocalStorage.saveSelectedCourses(selectedCourses);
    Navigator.pushNamed(context, '/enrollment', arguments: selectedCourses.map((code) {
      final course = courses.firstWhere((c) => c['code'] == code);
      return {'code': course['code'], 'title': course['name'], 'campus': 'Laucala'};
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomHeader(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select up to 4 SBM courses", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: courses.map((course) {
                  final sem = courseAvailability[course['course_availability_id']]?['semester'] ?? [];
                  final prerequisites = course['prerequisites'] ?? [];
                  final availableSemesters = sem.isNotEmpty ? sem : [];

                  return Card(
                    child: CheckboxListTile(
                      title: Text("${course['code']} - ${course['name']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display prerequisites if available
                          if (prerequisites.isNotEmpty)
                            Text(
                              "Prerequisites: ${prerequisites.join(', ')}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          
                          // Display available semesters if any
                          if (availableSemesters.isNotEmpty)
                            Text(
                              "Available in: ${((availableSemesters is List ? availableSemesters : [availableSemesters]) ?? []).join(', ')}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          
                          // Display message if there are no prerequisites or available semesters
                          if (prerequisites.isEmpty && availableSemesters.isEmpty)
                            const Text(
                              "No prerequisites or availability info",
                              style: TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                      value: selectedCourses.contains(course['code']),
                      onChanged: (course['prerequisites'] == null || course['prerequisites'].every(selectedCourses.contains))
                          ? (bool? val) => toggleCourseSelection(course)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: selectedCourses.isNotEmpty ? proceedToEnrollment : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Proceed to Enrollment"),
            ),
            const SizedBox(height: 20),
            CustomFooter(screenWidth: screenWidth),
          ],
        ),
      ),
    );
  }
}
