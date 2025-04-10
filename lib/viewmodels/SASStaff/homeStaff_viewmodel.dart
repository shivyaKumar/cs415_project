import 'package:flutter/material.dart';

class HomeStaffViewModel extends ChangeNotifier {
  // Tracks whether the student account is on hold
  bool _isStudentOnHold = false;

  bool get isStudentOnHold => _isStudentOnHold;

  // List of hardcoded staff members
  final List<Map<String, String>> staffList = [
    {'id': 'SS1064925', 'firstName': 'Alice', 'lastName': 'Johnson'},
    {'id': 'SS10565294', 'firstName': 'Bob', 'lastName': 'Williams'},
  ];

  String _staffName = 'Unknown Staff'; // Default staff name

  String get staffName => _staffName;

  // Dynamically assign staff name based on login ID
  void setStaffName(String id) {
    final staff = staffList.firstWhere(
      (staff) => staff['id'] == id,
      orElse: () => {'firstName': 'Unknown', 'lastName': 'Staff'},
    );
    _staffName = '${staff['firstName']} ${staff['lastName']}';
    notifyListeners();
  }

  // Handles logout functionality
  void handleLogout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/');
  }

  // Handles navigation to the Register Student page
  void navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/registerStudent');
  }

  // Handles navigation to the Edit Student page
  void navigateToEdit(BuildContext context) {
    Navigator.pushNamed(context, '/editStudent');
  }

  // Puts a student account on hold
  void putStudentOnHold(BuildContext context) {
    _isStudentOnHold = true;
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Student account put on hold!")),
    );
  }

  // Resets the student account hold status
  void resetStudentHoldStatus() {
    _isStudentOnHold = false;
    notifyListeners();
  }
}