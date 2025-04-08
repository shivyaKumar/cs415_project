// ViewModel for Course Enrollment Page
// Applies SRP (handles only business logic, not UI) and OOP (encapsulation)
import 'package:flutter/material.dart';
import '../../models/student/enrolled_course_model.dart';

class CourseEnrollmentViewModel extends ChangeNotifier {
  // Private list holding currently active (enrolled) courses
  final List<EnrolledCourse> _activeCourses = [];

  // Private list holding dropped or not approved courses
  final List<EnrolledCourse> _droppedCourses = [];

  // Public getter for active courses (encapsulation)
  List<EnrolledCourse> get activeCourses => _activeCourses;

  // Public getter for dropped courses (encapsulation)
  List<EnrolledCourse> get droppedCourses => _droppedCourses;

  // Simulates loading enrolled courses from a backend or database
  Future<void> loadEnrolledCourses() async {
    await Future.delayed(const Duration(milliseconds: 400));
    _activeCourses.clear();

    // TODO: Fetch enrolled courses from backend API or local storage here

    notifyListeners(); // Notify UI to rebuild
  }

  // Simulates loading dropped/unapproved courses from a backend
  Future<void> loadDroppedCourses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _droppedCourses.clear();

    // TODO: Fetch dropped/unapproved courses from backend API or local storage here

    notifyListeners(); // Notify UI to rebuild
  }

  // Moves a course from active to dropped list
  void dropCourse(EnrolledCourse course) {
    _activeCourses.remove(course);
    _droppedCourses.add(course);
    notifyListeners();
  }
}
