import 'package:flutter/material.dart';

class HomeStaffViewModel extends ChangeNotifier {
  // Tracks whether the student account is on hold
  bool _isStudentOnHold = false;

  bool get isStudentOnHold => _isStudentOnHold;

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