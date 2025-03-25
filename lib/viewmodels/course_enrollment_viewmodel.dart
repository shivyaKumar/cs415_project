import 'package:flutter/material.dart';

class CourseEnrollmentController with ChangeNotifier {
  // Example program (used when adding courses).
  final String program = "Bachelor of Software Engineering";

  // Available semesters
  final List<String> semesters = ["Semester I, 2025", "Semester II, 2025"];

  // Currently selected semester
  int selectedSemesterIndex = 0;

  // Enrollment lists
  final List<String> activeRegistrations = [];
  final List<String> droppedRegistrations = [];

  /// Called when user selects a semester
  void selectSemester(int index) {
    selectedSemesterIndex = index;
    notifyListeners();
  }

  /// Add courses to the active registrations
  void addCourses(List<String> courses) {
    activeRegistrations.addAll(courses);
    notifyListeners();
  }

  /// Open a link (stub)
  Future<void> openLink(String url) async {
    debugPrint('Opening link: $url');
    // Implement url_launcher or similar if needed
  }

  /// Handle "Add Course" flow
  Future<void> onAddCourse(BuildContext context) async {
    // Replace this import with your actual AddCoursePage import
    // import 'addcourse.dart';

    final selectedCourses = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => /* AddCoursePage(
          program: program,
          maxSelectableCourses: 5,
        ), */
        // Temporarily just return a stub page or logic:
        Scaffold(
          appBar: AppBar(title: const Text("Add Course Page Stub")),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                // Example returning some dummy courses
                Navigator.pop<List<String>>(context, ["CS100", "CS101"]);
              },
              child: const Text("Select dummy courses & pop"),
            ),
          ),
        ),
      ),
    );

    if (selectedCourses != null && selectedCourses.isNotEmpty) {
      addCourses(selectedCourses);
    }
  }
}
