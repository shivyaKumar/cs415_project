import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/custom_header.dart';
import 'widgets/custom_footer.dart';
import '../../viewmodels/SASmanager/homeSAS_viewmodel.dart';

const Color headerTeal = Color(0xFF008080);

class SasManagerDashboard extends StatelessWidget {
  const SasManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => SasManagerDashboardViewModel(context),
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
        appBar: const CustomHeader(), // Use the custom header
        body: Consumer<SasManagerDashboardViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  viewModel.isRegistrationOpen
                      ? 'Registration is Open'
                      : 'Registration is Closed',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        _buildDashboardTile(
                          icon: Icons.lock_open,
                          title: 'Open Registration',
                          description: 'Enable students to register for courses.',
                          onTap: () => viewModel.handleTileTap('Open Registration'),
                        ),
                        _buildDashboardTile(
                          icon: Icons.lock,
                          title: 'Close Registration',
                          description: 'Disable course registration for students.',
                          onTap: () => viewModel.handleTileTap('Close Registration'),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomFooter(screenWidth: screenWidth), // Use the custom footer
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDashboardTile({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.indigo),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}