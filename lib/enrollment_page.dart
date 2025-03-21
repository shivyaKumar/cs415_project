import 'package:flutter/material.dart';
import '../services/local_storage.dart';

class EnrollmentPage extends StatefulWidget {
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

  Future<void> loadEnrolledCourses() async {
    List<String> courses = await LocalStorage.getSelectedCourses();
    setState(() {
      enrolledCourses = courses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Enrollment")),
      body: ListView.builder(
        itemCount: enrolledCourses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(enrolledCourses[index]),
          );
        },
      ),
    );
  }
}
