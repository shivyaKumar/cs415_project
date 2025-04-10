import 'package:flutter/material.dart';
import 'firebase_service.dart';
import 'models/student_course_fee_model.dart';
import 'models/hold_model.dart';
// SRP: Each class has a single responsibility, keeping logic focused on either data handling or state management.
  
// OCP: The classes are open for extension (e.g., adding more logic) without modifying existing code.

class FeesAndHoldsViewModel extends ChangeNotifier {
  List<StudentCourseFee> courseFees = [];
  List<Hold> holds = [];

  // Fetch course fees based on studentId
  Future<void> fetchCourseFees(String studentId) async {
    courseFees = await FirebaseService.fetchCourseFees(studentId);
    notifyListeners(); // Notify listeners that data has been updated
  }

  // Fetch holds based on studentId
  Future<void> fetchHolds(String studentId) async {
    holds = await FirebaseService.fetchHolds(studentId);
    notifyListeners(); // Notify listeners that data has been updated
  }
}
