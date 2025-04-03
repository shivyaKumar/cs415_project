import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Color headerTeal = Color(0xFF008080);

class HomeStaff extends StatelessWidget {
  const HomeStaff({super.key});

  void _handleLogout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/');
  }

  // Navigation functions
  void _navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/registerStudent');
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.pushNamed(context, '/editStudent');
  }

  void _navigateToDelete(BuildContext context) {
    Navigator.pushNamed(context, '/deleteStudent');
  }

  void _putOnHold(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Student account put on hold!")),
    );
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
                    'SAS Staff Dashboard',
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
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Welcome, SAS Staff Member!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: staffItems.length,
                itemBuilder: (context, index) {
                  return _buildDashboardCard(
                    staffItems[index]['icon'],
                    staffItems[index]['title'],
                    staffItems[index]['action'],
                    context,
                  );
                },
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.indigo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.admin_panel_settings, color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text(
                  'SAS Staff Menu',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.person_add, 'Register Student', _navigateToRegister, context),
          _buildDrawerItem(Icons.edit, 'Edit Student', _navigateToEdit, context),
          _buildDrawerItem(Icons.delete, 'Delete Student', _navigateToDelete, context),
          _buildDrawerItem(Icons.pause_circle_filled, 'Put Student on Hold', _putOnHold, context),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, Function(BuildContext) action, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () => action(context),
    );
  }

  Widget _buildDashboardCard(IconData icon, String title, Function(BuildContext) action, BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => action(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.indigo),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: headerTeal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              '© 2025 The University of the South Pacific',
              style: TextStyle(color: Colors.white),
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
          const Expanded(
            child: Text(
              'Laucala Campus, Suva, Fiji',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Updated list with actions
final List<Map<String, dynamic>> staffItems = [
  {'icon': Icons.person_add, 'title': 'Register Student', 'action': (context) => Navigator.pushNamed(context, '/registerStudent')},
  {'icon': Icons.edit, 'title': 'Edit Student', 'action': (context) => Navigator.pushNamed(context, '/editStudent')},
  {'icon': Icons.delete, 'title': 'Delete Student', 'action': (context) => Navigator.pushNamed(context, '/deleteStudent')},
  {'icon': Icons.pause_circle_filled, 'title': 'Put on Hold', 'action': (context) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Student account put on hold!")))},
];
