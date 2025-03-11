import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Color headerTeal = Color(0xFF008080); // Define the headerTeal color

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  void _handleLogout(BuildContext context) {
    // Navigate back to the Login screen.
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50], // Light background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160), // Adjusted height to match login page header size
        child: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
              color: Colors.white, // Make burger menu icon white
            ),
          ),
          flexibleSpace: Stack(
            fit: StackFit.expand,
            children: [
              // USP Logo Image, shifted to the right
              Positioned(
                left: 0, // Shifted right by 20 pixels (adjust this value as needed)
                right: 0, // Ensures the image doesn't stretch
                child: Image.asset(
                  'assets/images/header.png', // Ensure this path points to your USP logo image
                  fit: BoxFit.cover,
                ),
              ),
              // Title Text in the center of the header
              Positioned(
                top: 60, // Adjusted to center the text vertically
                left: 0,
                right: 0,
                child: Center(
                  child: const Text(
                    'USP Student Management',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Logout icon button, positioned on the right (kept for now, can remove if not needed)
              Positioned(
                top: 30, // Adjusted based on your preference
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
          backgroundColor: Colors.transparent, // Make background transparent for the image to show
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.indigo),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.school, color: Colors.white, size: 40),
                  SizedBox(height: 10),
                  Text(
                    'Student Menu',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.person, 'Profile', context),
            _buildDrawerItem(Icons.book, 'Courses', context),
            _buildDrawerItem(Icons.event, 'Exams', context),
            _buildDrawerItem(Icons.bar_chart, 'Results', context),
            _buildDrawerItem(Icons.settings, 'Settings', context),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Welcome to USP Student Management',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2, // Adjusted for better spacing
              ),
              itemCount: dashboardItems.length,
              itemBuilder: (context, index) {
                return _buildDashboardCard(dashboardItems[index]['icon'], dashboardItems[index]['title']);
              },
            ),
          ),
          Container(
            width: double.infinity,
            color: headerTeal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left column (Expanded)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Copyright / Contact row
                      Row(
                        children: [
                          InkWell(
                            onTap: () => _openLink(
                                'https://www.example.com/copyright'),
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
                            onTap: () =>
                                _openLink('https://www.example.com/contact'),
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

                // Center column (SVG logo)
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

                // Right column (Expanded)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        'The University of the South Pacific',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Laucala Campus, Suva, Fiji',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Tel: +679 323 1000',
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

  void _openLink(String url) {
    // Implement the logic to open the link
    print('Opening link: $url');
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildDashboardCard(IconData icon, String title) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {},
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
}

final List<Map<String, dynamic>> dashboardItems = [
  {'icon': Icons.person, 'title': 'Profile'},
  {'icon': Icons.book, 'title': 'Courses'},
  {'icon': Icons.event, 'title': 'Exams'},
  {'icon': Icons.bar_chart, 'title': 'Results'},
  {'icon': Icons.settings, 'title': 'Settings'},
];
