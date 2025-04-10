import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'firebase_service.dart';
import 'models/student_course_fee_model.dart';
import 'models/hold_model.dart';
import 'fees_and_holds_page.dart'; // Import the new Fees and Holds page

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  void _handleLogout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('USP Student Management Homepage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
            tooltip: 'Logout',
          ),
          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text(
                'Student Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _buildDrawerItem(context, Icons.person, 'Profile', '/profile'),
            _buildDrawerItem(context, Icons.book, 'Courses', '/course-selection'),
            _buildDrawerItem(context, Icons.event, 'Exams', null),
            _buildDrawerItem(context, Icons.bar_chart, 'Results', null),
            _buildDrawerItem(context, Icons.settings, 'Settings', null),
            // Add the new drawer item for Fees and Holds
            _buildDrawerItem(context, Icons.attach_money, 'Fees and Holds', '/fees-and-holds'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Welcome to the USP Student Management System!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildDashboardCard(context, Icons.person, 'Student Profile', '/profile'),
                  _buildDashboardCard(context, Icons.book, 'Courses', '/course-selection'),
                  _buildDashboardCard(context, Icons.event, 'Exams', null),
                  _buildDashboardCard(context, Icons.bar_chart, 'Results', null),
                  _buildDashboardCard(context, Icons.settings, 'Settings', null),
                  // Add a dashboard card for Fees and Holds
                  _buildDashboardCard(context, Icons.attach_money, 'Fees and Holds', '/fees-and-holds'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _handleLogout(context),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, IconData icon, String title, String? route) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.indigo),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, String? route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
    );
  }
}
