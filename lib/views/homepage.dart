import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/homepage_viewmodel.dart';
import 'widgets/custom_footer.dart';
import 'widgets/custom_header.dart';

class Homepage extends StatelessWidget {
  final String username;

  const Homepage({super.key, required this.username});

  Widget _buildFeatureTile({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF083057),
      elevation: 4,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.blueGrey.withAlpha(51),
        splashColor: Colors.blue.withAlpha(51),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 70, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final homepageViewModel = Provider.of<HomepageViewModel>(context);
    homepageViewModel.username = username;

    return Scaffold(
      appBar: const CustomHeader(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/homepage.png',
                  width: double.infinity,
                  height: 350,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 350,
                  color: Colors.black.withAlpha(77),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Welcome to USP Student Services',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your one-stop hub for enrollment, course management,\nacademic success.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Card(
                color: const Color(0xFFF6F0FB),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GridView.count(
                    crossAxisCount: screenWidth < 600 ? 2 : 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildFeatureTile(
                        label: 'My Profile',
                        icon: Icons.person,
                        onTap: () => Navigator.pushNamed(context, '/profile'),
                      ),
                      _buildFeatureTile(
                        label: 'My Enrollment',
                        icon: Icons.how_to_reg,
                        onTap: () => Navigator.pushNamed(context, '/myEnrollment'),
                      ),
                      _buildFeatureTile(
                        label: 'Courses',
                        icon: Icons.menu_book,
                        onTap: () => Navigator.pushNamed(context, '/courses'),
                      ),
                      _buildFeatureTile(
                        label: 'Finance',
                        icon: Icons.attach_money,
                        onTap: () => Navigator.pushNamed(context, '/finance'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            CustomFooter(screenWidth: screenWidth),
          ],
        ),
      ),
    );
  }
}
