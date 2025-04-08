import 'package:flutter/material.dart';
import 'SASManage_viewmodel.dart';

class RemoveStaffViewModel extends ChangeNotifier {
  bool isManagerSelected = true;

  final SASManageViewModel manageViewModel;

  RemoveStaffViewModel({required this.manageViewModel});

  // Get the current list based on the selection
  List<dynamic> get currentList =>
      isManagerSelected ? manageViewModel.managers : manageViewModel.staff;

  // Toggle between managers and staff
  void toggleSelection(bool isManager) {
    isManagerSelected = isManager;
    notifyListeners();
  }

  // Remove a user (manager or staff)
  void removeUser(dynamic user) {
    if (isManagerSelected) {
      manageViewModel.removeManager(manageViewModel.managers.indexOf(user));
    } else {
      manageViewModel.removeStaff(manageViewModel.staff.indexOf(user));
    }
    notifyListeners();
  }
}