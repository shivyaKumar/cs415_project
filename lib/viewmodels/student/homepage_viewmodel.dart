import 'package:flutter/material.dart';

/// HomepageViewModel is responsible for managing homepage-specific logic
/// such as handling logout and storing the current username.
class HomepageViewModel with ChangeNotifier {
  /// The current username. This might be set during login.
  String username = "Student";

  /// Logout logic: Navigates back to the login screen.
  void logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }
}
