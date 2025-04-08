import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/sAdmin/superAdmin_viewmodel.dart';

const Color headerTeal = Color(0xFF008080);

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SuperAdminDashboardViewModel(context),
      child: Consumer<SuperAdminDashboardViewModel>(
        builder: (context, viewModel, child) {
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
                          'Super Admin Dashboard',
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
                        onPressed: viewModel.handleLogout,
                        tooltip: 'Logout',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(color: headerTeal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.supervisor_account, color: Colors.white, size: 40),
                        SizedBox(height: 10),
                        Text(
                          'Super Admin Menu',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                  _buildDrawerItem(
                    Icons.admin_panel_settings,
                    'Manage SAS Managers',
                    () => viewModel.manageSasManagers(),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Welcome, Super Admin!',
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
                      childAspectRatio: 1.2,
                    ),
                    itemCount: 1, // Only one item for managing SAS Managers
                    itemBuilder: (context, index) {
                      return _buildDashboardCard(
                        Icons.admin_panel_settings,
                        'Manage SAS Managers',
                        () => viewModel.manageSasManagers(),
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: headerTeal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '© 2025 The University of the South Pacific',
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
                            Text(
                              'Laucala Campus, Suva, Fiji',
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
        },
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: headerTeal),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  Widget _buildDashboardCard(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: headerTeal),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}