import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditStudentViewModel extends ChangeNotifier {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("students");
  List<Map<String, dynamic>> students = [];
  bool isLoading = false; // Add the isLoading property

  /// Fetch all students from the database
  Future<void> fetchStudents() async {
    isLoading = true; // Set loading to true
    notifyListeners();

    try {
      final snapshot = await _database.get();
      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value;
        if (data is Map<dynamic, dynamic>) {
          students = data.entries.map((entry) {
            final student = entry.value as Map<dynamic, dynamic>;
            return {
              'id': entry.key.toString(), // Cast key to String
              ...student.map((key, value) => MapEntry(key.toString(), value)), // Cast keys to String
            };
          }).toList();
        } else {
          students = []; // Handle unexpected data structure
        }
      } else {
        students = []; // Handle empty database
      }
    } catch (e) {
      debugPrint("Error fetching students: $e");
    } finally {
      isLoading = false; // Set loading to false
      notifyListeners();
    }
  }

  /// Delete a student from the database
  Future<void> deleteStudent(String studentId) async {
    try {
      await _database.child(studentId).remove();
      students.removeWhere((student) => student['id'] == studentId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting student: $e");
    }
  }
}