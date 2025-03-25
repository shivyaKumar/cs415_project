import 'dart:async';
import 'package:flutter/material.dart';

class LoginViewModel with ChangeNotifier {
  // Validate student email using a regex.
  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[Ss][0-9]{8}@student\.usp\.ac\.fj$');
    return emailRegex.hasMatch(email);
  }
  
  // Simulate a login API call.
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real implementation, use an API call and return user data.
    return "Student";
  }
}
