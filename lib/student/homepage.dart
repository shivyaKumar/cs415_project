import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  void _handleLogout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
              color: Colors.white,
            ),
          ),
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
                    'Student Dashboard',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Text(
                'Student Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Courses'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Exams'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Results'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _handleLogout(context),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Greetings Student!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        _buildDashboardCard(Icons.person, 'Student Profile', () {
                          Navigator.pushNamed(context, '/profile');
                        }),
                        _buildDashboardCard(Icons.book, 'Courses', () {
                          Navigator.pushNamed(context, '/course_selection');
                        }),
                        _buildDashboardCard(Icons.event, 'Exams', () {}),
                        _buildDashboardCard(Icons.bar_chart, 'Results', () {}),
                        _buildDashboardCard(Icons.settings, 'Settings', () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
    
  }

  Widget _buildDashboardCard(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
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

  Widget _buildFooter({double height = 80}) {
    return SizedBox(
      height: height,
      child: Container(
        width: double.infinity,
        color: Colors.teal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _openLink('https://www.example.com/copyright'),
                        child: const Text(
                          'Copyright',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('|', style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => _openLink('https://www.example.com/contact'),
                        child: const Text(
                          'Contact Us',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '© Copyright 1968 - 2025. All Rights Reserved.',
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
                  Text('The University of the South Pacific', style: TextStyle(color: Colors.white)),
                  Text('Laucala Campus, Suva, Fiji', style: TextStyle(color: Colors.white)),
                  Text('Tel: +679 323 1000', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openLink(String url) {
    print('Opening link: $url');
  }
}