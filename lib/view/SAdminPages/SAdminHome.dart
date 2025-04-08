import 'widgets/custom_footer.dart';
import 'widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/sAdmin/superAdmin_viewmodel.dart';

const Color headerTeal = Color(0xFF008080);

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (_) => SuperAdminDashboardViewModel(),
      child: Consumer<SuperAdminDashboardViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.indigo[50],
            appBar: const CustomHeader(
              title: 'Super Admin Dashboard',
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
                    Icons.person_remove,
                    'Remove Managers and Staffs',
                    () => viewModel.deleteSasManager(context, ''), // Pass context here
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
                    itemCount: 1, // Two items: Add and Remove Managers and Staff
                    itemBuilder: (context, index) {
                        return _buildDashboardCard(
                          Icons.person_remove,
                          'Remove Managers and Staffs',
                          () => viewModel.deleteSasManager(context, ''),
                        );
                    },
                  ),
                ),
              ],
            ),
            bottomNavigationBar: CustomFooter(screenWidth: screenWidth),
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