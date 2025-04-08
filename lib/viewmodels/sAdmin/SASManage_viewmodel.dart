import 'package:flutter/material.dart';
import '../../models/sAdmin/SASManager_model.dart';
import '../../models/sAdmin/SASStaff_model.dart';

class SASManageViewModel extends ChangeNotifier {
  // Hardcoded managers
  final List<SASManagerModel> managers = [
    SASManagerModel(
      id: 'SA1120121',
      firstName: 'John',
      lastName: 'Doe',
      email: 'SA1120121@manager.usp.ac.fj',
      qualification: 'Degree',
      fieldOfQualification: 'Business Administration',
    ),
    SASManagerModel(
      id: 'SA1110122',
      firstName: 'Jane',
      lastName: 'Smith',
      email: 'SA1110122@manager.usp.ac.fj',
      qualification: 'Degree',
      fieldOfQualification: 'Management',
    ),
  ];

  // Hardcoded staff
  final List<SASStaffModel> staff = [
    SASStaffModel(
      id: 'SS1064925',
      firstName: 'Alice',
      lastName: 'Johnson',
      email: 'SS1064925@staff.usp.ac.fj',
      employmentType: 'Full-time',
    ),
    SASStaffModel(
      id: 'SS10565294',
      firstName: 'Bob',
      lastName: 'Williams',
      email: 'SS10565294@staff.usp.ac.fj',
      employmentType: 'Part-time',
    ),
  ];

  // Active card state
  bool isManagerActive = true;

  // Toggle between manager and staff
  void toggleActiveCard(bool isManager) {
    isManagerActive = isManager;
    notifyListeners();
  }

  // Remove a manager by index
  void removeManager(int index) {
    managers.removeAt(index);
    notifyListeners();
  }

  // Remove a staff member by index
  void removeStaff(int index) {
    staff.removeAt(index);
    notifyListeners();
  }
}