import 'package:flutter/material.dart';

class RegistrationStatusViewModel extends ChangeNotifier {
  bool _isRegistrationOpen = true;

  bool get isRegistrationOpen => _isRegistrationOpen;

  void openRegistration() {
    _isRegistrationOpen = true;
    notifyListeners();
  }

  void closeRegistration() {
    _isRegistrationOpen = false;
    notifyListeners();
  }
}