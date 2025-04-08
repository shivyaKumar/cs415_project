import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../registrationStatus_viewmodel.dart';

class SasManagerDashboardViewModel extends ChangeNotifier {
  final BuildContext context;

  SasManagerDashboardViewModel(this.context);

  void handleLogout() {
    Navigator.pushReplacementNamed(context, '/');
  }

  void handleTileTap(String action) {
    final registrationStatus = Provider.of<RegistrationStatusViewModel>(context, listen: false);

    if (action == 'Open Registration') {
      registrationStatus.openRegistration();
      _showSnackBar('Registration is now open!');
    } else if (action == 'Close Registration') {
      registrationStatus.closeRegistration();
      _showSnackBar('Registration is now closed!');
    }
  }

  void navigateToCourseSelection() {
    final registrationStatus = Provider.of<RegistrationStatusViewModel>(context, listen: false);

    if (registrationStatus.isRegistrationOpen) {
      Navigator.pushNamed(context, '/course_selection');
    } else {
      _showDialog(
        title: 'Registrations Closed',
        content: 'Registrations are currently closed.',
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}