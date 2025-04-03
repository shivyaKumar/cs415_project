import 'package:flutter/material.dart';
import '../services/local_storage.dart';

class CourseEnrollmentViewModel extends ChangeNotifier {
  // List of enrolled courses
  final List<String> _enrolledCourses = [];

  // Public getter for enrolled courses
  List<String> get enrolledCourses => _enrolledCourses;

  // Loads enrolled courses from local storage
  Future<void> loadEnrolledCourses() async {
    List<String> courses = await LocalStorage.getSelectedCourses();
    _enrolledCourses.clear();
    _enrolledCourses.addAll(courses);
    notifyListeners(); // Notify UI to rebuild
  }
}