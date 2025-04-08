import 'package:flutter/material.dart';

class SuperAdminDashboardViewModel extends ChangeNotifier {
  SuperAdminDashboardViewModel();

  void handleLogout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/');
  }

  void deleteSasManager(BuildContext context, String managerId) {
    // Logic to delete a SAS Manager
    Navigator.pushNamed(context, '/removestaff');
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void showConfirmationDialog({
    required BuildContext context,
    String title = 'Confirmation',
    String content = 'Are you sure?',
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              onConfirm(); // Execute the confirmation action
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}