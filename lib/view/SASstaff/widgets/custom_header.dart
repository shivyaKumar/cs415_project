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
                Navigator.pushNamed(context, '/homeStaff'); // Navigate to Home
                break;
              case 'register':
                Navigator.pushNamed(context, '/registerStudent'); // Navigate to Register Student
                break;
              case 'edit':
                Navigator.pushNamed(context, '/editStudent'); // Navigate to Edit Student
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

            // Home
            PopupMenuItem<String>(
              value: 'home',
              child: Container(
                color: (currentRoute == '/homeStaff') ? navbarBlue : null,
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: (currentRoute == '/homeStaff') ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(
                      color: (currentRoute == '/homeStaff') ? Colors.white : Colors.black,
                      fontWeight: (currentRoute == '/homeStaff') ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),

            // Register
            PopupMenuItem<String>(
              value: 'register',
              child: Container(
                color: (currentRoute == '/registerStudent') ? navbarBlue : null,
                child: ListTile(
                  leading: Icon(
                    Icons.app_registration,
                    color: (currentRoute == '/registerStudent') ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'Register',
                    style: TextStyle(
                      color: (currentRoute == '/registerStudent') ? Colors.white : Colors.black,
                      fontWeight: (currentRoute == '/registerStudent') ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),

            // Edit
            PopupMenuItem<String>(
              value: 'edit',
              child: Container(
                color: (currentRoute == '/editStudent') ? navbarBlue : null,
                child: ListTile(
                  leading: Icon(
                    Icons.edit,
                    color: (currentRoute == '/editStudent') ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'Edit',
                    style: TextStyle(
                      color: (currentRoute == '/editStudent') ? Colors.white : Colors.black,
                      fontWeight: (currentRoute == '/editStudent') ? FontWeight.bold : FontWeight.normal,
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