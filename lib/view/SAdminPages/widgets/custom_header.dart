import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/sAdmin/superAdmin_viewmodel.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title; // Dynamic title

  const CustomHeader({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  static const Color navbarBlue = Color.fromARGB(255, 8, 45, 87);

  @override
  Widget build(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    final superAdminViewModel = Provider.of<SuperAdminDashboardViewModel>(context, listen: false);

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
          Text(
            title, // Use the dynamic title
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
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
                Navigator.pushNamed(context, '/homeSA'); // Navigate to Home
                break;
              case 'removestaff':
                Navigator.pushNamed(context, '/removestaff'); // Navigate to Remove Staff
                break;
              case 'logout':
                _handleLogout(context, superAdminViewModel); // Handle logout
                break;
            }
          },
          child: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.menu, size: 32, color: Colors.white),
          ),
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'home',
              child: Container(
                color: (currentRoute == '/homeSA') ? navbarBlue : null,
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: (currentRoute == '/homeSA') ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(
                      color: (currentRoute == '/homeSA') ? Colors.white : Colors.black,
                      fontWeight: (currentRoute == '/homeSA') ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'removestaff',
              child: Container(
                color: (currentRoute == '/removestaff') ? navbarBlue : null,
                child: ListTile(
                  leading: Icon(
                    Icons.person_remove,
                    color: (currentRoute == '/removestaff') ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'Remove Staff',
                    style: TextStyle(
                      color: (currentRoute == '/removestaff') ? Colors.white : Colors.black,
                      fontWeight: (currentRoute == '/removestaff') ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
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

  void _handleLogout(BuildContext context, SuperAdminDashboardViewModel viewModel) {
    // Perform any logout-related logic, such as clearing session data
    viewModel.handleLogout(context); // Pass the context to the handleLogout method
    // Navigate to the login page
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}