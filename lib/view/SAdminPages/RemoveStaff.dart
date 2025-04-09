import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/sAdmin/removeStaff_viewmodel.dart';
import 'widgets/custom_header.dart';
import 'widgets/custom_footer.dart';

class RemoveStaffPage extends StatelessWidget {
  const RemoveStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RemoveStaffViewModel>();
    final isManagerSelected = viewModel.isManagerSelected;
    final screenWidth = MediaQuery.of(context).size.width;

    // Get the current list (managers or staff)
    final items = viewModel.currentList;

    return Scaffold(
      appBar: CustomHeader(
        title: isManagerSelected ? 'View & Remove Managers' : 'View & Remove Staff',
      ),
      body: Column(
        children: [
          // Toggle buttons to switch between Managers and Staff
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildToggleButton(
                context: context,
                title: 'Managers',
                isSelected: isManagerSelected,
                onTap: () => viewModel.toggleSelection(true),
              ),
              const SizedBox(width: 16),
              _buildToggleButton(
                context: context,
                title: 'Staff',
                isSelected: !isManagerSelected,
                onTap: () => viewModel.toggleSelection(false),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Display the list of Managers or Staff
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      isManagerSelected ? 'No Managers Found' : 'No Staff Found',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      if (isManagerSelected) {
                        final manager = items[index];
                        return ListTile(
                          title: Text('${manager.firstName} ${manager.lastName}'),
                          subtitle: Text(
                            'Qualification: ${manager.qualification}\nField: ${manager.fieldOfQualification}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showConfirmationDialog(context, viewModel, manager);
                            },
                          ),
                        );
                      } else {
                        final staff = items[index];
                        return ListTile(
                          title: Text('${staff.firstName} ${staff.lastName}'),
                          subtitle: Text('Employment Type: ${staff.employmentType}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showConfirmationDialog(context, viewModel, staff);
                            },
                          ),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomFooter(screenWidth: screenWidth),
    );
  }

  Widget _buildToggleButton({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.teal.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
              ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, RemoveStaffViewModel viewModel, dynamic user) {
    final isManagerSelected = viewModel.isManagerSelected;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Removal'),
          content: Text(
            isManagerSelected
                ? 'Are you sure you want to remove this manager?'
                : 'Are you sure you want to remove this staff member?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                viewModel.removeUser(user);
                Navigator.of(context).pop();
              },
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}