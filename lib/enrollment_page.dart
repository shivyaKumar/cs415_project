import 'package:flutter/material.dart';
import '../services/local_storage.dart';

class EnrollmentPage extends StatefulWidget {
  const EnrollmentPage({super.key});

  @override
  _EnrollmentPageState createState() => _EnrollmentPageState();
}

class _EnrollmentPageState extends State<EnrollmentPage> {
  List<String> enrolledCourses = [];

  @override
  void initState() {
    super.initState();
    loadEnrolledCourses();
  }

  /// Loads selected courses from local storage
  Future<void> loadEnrolledCourses() async {
    List<String> courses = await LocalStorage.getSelectedCourses();
    setState(() {
      enrolledCourses = courses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Enrolled Courses")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enrolled Courses",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            enrolledCourses.isEmpty
                ? const Center(
                    child: Text(
                      "No courses enrolled yet.",
                      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: enrolledCourses.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: const Icon(Icons.book, color: Colors.blue),
                            title: Text(
                              enrolledCourses[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
