import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/SASmanager/homeSAS_viewmodel.dart';

const Color headerTeal = Color(0xFF008080);

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () {
              // Access the SasManagerDashboardViewModel and call the logout method
              Provider.of<SasManagerDashboardViewModel>(context, listen: false).handleLogout();
            },
          ),
        ],
      ),
    );
  }
}