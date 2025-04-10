import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/homepage_viewmodel.dart';

/// CustomHeader is a reusable widget that implements a responsive AppBar with a logo and user menu.
///
/// SOLID Principles:
/// - SRP (Single Responsibility Principle): Handles only header layout and behavior.
/// - DIP (Dependency Inversion Principle): Depends on ViewModel abstraction for logic.
class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  static const Color navbarBlue = Color.fromARGB(255, 8, 45, 87);

  const CustomHeader({super.key});

  // This height is updated during build and reused in preferredSize (LSP)
  static double _lastCalculatedHeight = 64;

  @override
  Widget build(BuildContext context) {
    final homepageViewModel = Provider.of<HomepageViewModel>(context);
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Dynamically calculate header height
    final double dynamicHeight = screenWidth < 500 ? 56 : (screenWidth > 1000 ? 72 : 64);
    final double logoHeight = dynamicHeight - 16;
    final double iconSize = dynamicHeight - 30;

    // Save height to use in preferredSize getter
    _lastCalculatedHeight = dynamicHeight;

    return PreferredSize(
      preferredSize: Size.fromHeight(dynamicHeight), // LSP: matches what Scaffold expects
      child: AppBar(
        backgroundColor: const Color(0xFF009999),
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: dynamicHeight,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: SvgPicture.asset(
            'assets/images/usp_logo.svg',
            height: logoHeight,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: PopupMenuButton<String>(
              offset: Offset(0, dynamicHeight),
              icon: Icon(Icons.person, size: iconSize, color: Colors.white),
              onSelected: (value) {
                switch (value) {
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
                    homepageViewModel.logout(context);
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  enabled: false,
                  child: Text('Hi, ${homepageViewModel.username}'),
                ),
                const PopupMenuDivider(),
                _menuItem('profile', Icons.person, 'Profile', currentRoute),
                _menuItem('myEnrollment', Icons.how_to_reg, 'My Enrollment', currentRoute),
                _menuItem('courses', Icons.menu_book, 'Courses', currentRoute),
                _menuItem('finance', Icons.attach_money, 'Finance', currentRoute),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Logout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds individual popup items with conditional highlight.
  /// SRP: Does only one thing – builds menu entry.
  PopupMenuItem<String> _menuItem(
    String value,
    IconData icon,
    String title,
    String? currentRoute,
  ) {
    final bool isActive = currentRoute == '/$value';
    return PopupMenuItem<String>(
      value: value,
      child: Container(
        color: isActive ? navbarBlue : null,
        child: ListTile(
          leading: Icon(icon, color: isActive ? Colors.white : Colors.black),
          title: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  /// Returns preferred size. Uses previously calculated height from build context.
  /// Fulfills LSP by maintaining contract with PreferredSizeWidget.
  @override
  Size get preferredSize => Size.fromHeight(_lastCalculatedHeight);
}
