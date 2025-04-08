import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/student/homepage_viewmodel.dart';

/// A reusable header widget (AppBar) for pages that share
/// the same user menu, except login.
class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // We can reuse the same highlight color that we used in other pages
  static const Color navbarBlue = Color.fromARGB(255, 8, 45, 87);

  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the HomepageViewModel to handle logout, username, etc.
    final homepageViewModel = Provider.of<HomepageViewModel>(context);

    // Grab the current route name to highlight the active page
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return AppBar(
      backgroundColor: const Color(0xFF009999),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: SvgPicture.asset(
              'assets/images/usp_logo.svg',
              height: 50,
              width: 70,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          offset: const Offset(0, kToolbarHeight),
          onSelected: (value) {
            switch (value) {
              case 'home':
                Navigator.pushNamed(context, '/homepage'); // Navigate to Home
                break;
              case 'profile':
                Navigator.pushNamed(context, '/profile');
                break;
              case 'myEnrollment':
                Navigator.pushNamed(context, '/myEnrollment');
                break;
              case 'courses':
                Navigator.pushNamed(context, '/courses');
                break;
              case 'finance':
                Navigator.pushNamed(context, '/finance');
                break;
              case 'logout':
                // Delegate logout to the ViewModel
                homepageViewModel.logout(context);
                break;
            }
          },
          child: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.person, size: 32, color: Colors.white),
          ),
          // We highlight the current route by comparing currentRoute
          itemBuilder: (context) => [
            // Display the username from the ViewModel
            PopupMenuItem<String>(
              enabled: false,
              child: Text('Hi, ${homepageViewModel.username ?? 'Guest'}'),
            ),
            const PopupMenuDivider(),

            PopupMenuItem<String>(
              value: 'home',
              child: Container(
                color: (currentRoute == '/homepage') ? navbarBlue : null,
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: (currentRoute == '/homepage') ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(
                      color: (currentRoute == '/homepage') ? Colors.white : Colors.black,
                      fontWeight: (currentRoute == '/homepage') ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),

            // Profile
            PopupMenuItem<String>(
              value: 'profile',
              child: Container(
                // If we are currently on '/profile', highlight in navbarBlue
                color: (currentRoute == '/profile') ? navbarBlue : null,
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: (currentRoute == '/profile') ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'Profile',
                    style: TextStyle(
                      color: (currentRoute == '/profile') ? Colors.white : Colors.black,
                      fontWeight: (currentRoute == '/profile') ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),

            // My Enrollment
            PopupMenuItem<String>(
              value: 'myEnrollment',
              child: Container(
                color: (currentRoute == '/myEnrollment') ? navbarBlue : null,
                child: ListTile(
                  leading: Icon(
                    Icons.how_to_reg,
                    color: (currentRoute == '/myEnrollment') ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'My Enrollment',
                    style: TextStyle(
                      color: (currentRoute == '/myEnrollment') ? Colors.white : Colors.black,
                      fontWeight: (currentRoute == '/myEnrollment') ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),

            // Courses
            PopupMenuItem<String>(
              value: 'courses',
              child: Container(
                color: (currentRoute == '/courses') ? navbarBlue : null,
                child: ListTile(
                  leading: Icon(
                    Icons.menu_book,
                    color: (currentRoute == '/courses') ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'Courses',
                    style: TextStyle(
                      color: (currentRoute == '/courses') ? Colors.white : Colors.black,
                      fontWeight: (currentRoute == '/courses') ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),

            // Finance
            PopupMenuItem<String>(
              value: 'finance',
              child: Container(
                color: (currentRoute == '/finance') ? navbarBlue : null,
                child: ListTile(
                  leading: Icon(
                    Icons.attach_money,
                    color: (currentRoute == '/finance') ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'Finance',
                    style: TextStyle(
                      color: (currentRoute == '/finance') ? Colors.white : Colors.black,
                      fontWeight: (currentRoute == '/finance') ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),

            const PopupMenuDivider(),

            // Logout
            const PopupMenuItem<String>(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}