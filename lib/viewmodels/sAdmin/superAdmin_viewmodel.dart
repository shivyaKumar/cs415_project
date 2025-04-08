import 'package:flutter/material.dart';

class SuperAdminDashboardViewModel extends ChangeNotifier {
  final BuildContext context;

  SuperAdminDashboardViewModel(this.context);

  void handleLogout() {
    Navigator.pushReplacementNamed(context, '/');
  }

  void manageSasManagers() {
    Navigator.pushNamed(context, '/sas_manage');
  }

  void deleteSasManager(String managerId) {
    // Logic to delete a SAS Manager
    // For now, just show a confirmation dialog
    _showDialog(
      title: 'Delete SAS Manager',
      content: 'Are you sure you want to delete SAS Manager with ID: $managerId?',
      onConfirm: () {
        // Perform deletion logic here
        Navigator.pop(context); // Close the dialog
        _showSnackBar('SAS Manager with ID: $managerId has been deleted.');
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showDialog({
    required String title,
    required String content,
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
            onPressed: onConfirm,
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}