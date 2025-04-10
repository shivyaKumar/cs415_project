import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomepageViewModel with ChangeNotifier {
  /// The current username. This might be set during login.
  String username = "Guest";

  /// Fetch the first name of the logged-in student from Firebase.
  Future<void> fetchUsername(String studentId) async {
    try {
      final normalizedStudentId = studentId.trim(); // Trim spaces
      debugPrint("Fetching username for student ID: '$normalizedStudentId'");
      final database = FirebaseDatabase.instance.ref("students/$normalizedStudentId");
      final snapshot = await database.get();

      if (snapshot.exists) {
        final studentData = snapshot.value as Map<dynamic, dynamic>;
        username = studentData['firstName'] ?? "Guest";
        debugPrint("Fetched username: $username");
        notifyListeners(); // Notify listeners to update the UI
      } else {
        debugPrint("Student ID not found in the database: $normalizedStudentId");
      }
    } catch (e) {
      debugPrint("Error fetching student data: $e");
    }
  }

  /// Logout logic: Navigates back to the login screen.
  void logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }
}