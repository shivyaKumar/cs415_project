import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/registrationStatus_viewmodel.dart';

const Color headerTeal = Color(0xFF008080);

class SasManagerDashboard extends StatefulWidget {
  const SasManagerDashboard({super.key});

  @override
  State<SasManagerDashboard> createState() => _SasManagerDashboardState();
}

class _SasManagerDashboardState extends State<SasManagerDashboard> {
  bool isRegistrationOpen = false; // Tracks whether registration is open or closed

  void _handleLogout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/');
  }

  void _handleTileTap(String action, BuildContext context) {
    final registrationStatus = Provider.of<RegistrationStatusViewModel>(context, listen: false);

    if (action == 'Open Registration') {
      registrationStatus.openRegistration();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration is now open!')),
      );
    } else if (action == 'Close Registration') {
      registrationStatus.closeRegistration();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration is now closed!')),
      );
    }
  }

  void _navigateToCourseSelection(BuildContext context) {
    final registrationStatus = Provider.of<RegistrationStatusViewModel>(context, listen: false);

    if (registrationStatus.isRegistrationOpen) {
      Navigator.pushNamed(context, '/course_selection'); // Navigate to course selection page
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registrations Closed'),
          content: const Text('Registrations are currently closed.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: AppBar(
          flexibleSpace: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/header.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: const Center(
                  child: Text(
                    'SAS Manager Dashboard',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                top: 30,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => _handleLogout(context),
                  tooltip: 'Logout',
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Welcome, SAS Manager!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildDashboardTile(
                    icon: Icons.lock_open,
                    title: 'Open Registration',
                    description: 'Enable students to register for courses.',
                    onTap: () => _handleTileTap('Open Registration', context),
                  ),
                  _buildDashboardTile(
                    icon: Icons.lock,
                    title: 'Close Registration',
                    description: 'Disable course registration for students.',
                    onTap: () => _handleTileTap('Close Registration', context),
                  ),
                  _buildDashboardTile(
                    icon: Icons.school,
                    title: 'Course Selection',
                    description: 'Access the course selection page.',
                    onTap: () => _navigateToCourseSelection(context),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: headerTeal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '© 2025 The University of the South Pacific',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/usp_logo.svg',
                      width: 133,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        'Laucala Campus, Suva, Fiji',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTile({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.indigo),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}