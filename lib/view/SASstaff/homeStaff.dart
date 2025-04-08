import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/SASStaff/homeStaff_viewmodel.dart';
import 'widgets/custom_header.dart';
import 'widgets/custom_footer.dart';

const Color headerTeal = Color(0xFF008080);

class HomeStaff extends StatelessWidget {
  const HomeStaff({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeStaffViewModel>(context); // Access the ViewModel
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: const CustomHeader(), // Use the custom header
      drawer: _buildDrawer(context, viewModel),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Welcome, SAS Staff Member!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: staffItems.length,
                itemBuilder: (context, index) {
                  return _buildDashboardCard(
                    staffItems[index]['icon'],
                    staffItems[index]['title'],
                    staffItems[index]['action'],
                    context,
                    viewModel,
                  );
                },
              ),
            ),
            CustomFooter(screenWidth: screenWidth), // Use the custom footer
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, HomeStaffViewModel viewModel) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.indigo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.admin_panel_settings, color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text(
                  'SAS Staff Menu',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.person_add, 'Register Student', viewModel.navigateToRegister, context),
          _buildDrawerItem(Icons.edit, 'Edit Student', viewModel.navigateToEdit, context),
          _buildDrawerItem(Icons.pause_circle_filled, 'Put Student on Hold', viewModel.putStudentOnHold, context),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, Function(BuildContext) action, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () => action(context),
    );
  }

  Widget _buildDashboardCard(IconData icon, String title, Function(BuildContext) action, BuildContext context, HomeStaffViewModel viewModel) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => action(context),
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

// Updated list with actions
final List<Map<String, dynamic>> staffItems = [
  {'icon': Icons.person_add, 'title': 'Register Student', 'action': (context) => Provider.of<HomeStaffViewModel>(context, listen: false).navigateToRegister(context)},
  {'icon': Icons.edit, 'title': 'Edit Student', 'action': (context) => Provider.of<HomeStaffViewModel>(context, listen: false).navigateToEdit(context)},
  {'icon': Icons.pause_circle_filled, 'title': 'Put on Hold', 'action': (context) => Provider.of<HomeStaffViewModel>(context, listen: false).putStudentOnHold(context)},
];