import 'package:cs415_project/view/student/widgets/custom_header.dart';
import 'package:cs415_project/view/student/widgets/custom_footer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/registrationStatus_viewmodel.dart';

class CourseSelectionPage extends StatelessWidget {
  const CourseSelectionPage({super.key});

  void navigateTo(BuildContext context, String programName) {
    switch (programName) {
      case 'SAGEONS':
        Navigator.pushNamed(context, '/sageons');
        break;
      case 'STEMP':
        Navigator.pushNamed(context, '/stemp');
        break;
      case 'SOLASS':
        Navigator.pushNamed(context, '/solass');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$programName page is under development!')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width; // Dynamically get screen width
    final List<String> programs = ['SPACE', 'STEMP', 'SOLASS', 'SAGEONS', 'SAFE', 'SBM'];
    final registrationStatus = Provider.of<RegistrationStatusViewModel>(context);

    if (!registrationStatus.isRegistrationOpen) {
      return Scaffold(
        appBar: const CustomHeader(), // Use the custom header
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Registrations are currently closed.',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/enrollment'); // Navigate to enrollment page
              },
              child: const Text('View Enrolled Courses'),
            ),
          ],
        ),
        bottomNavigationBar: CustomFooter(screenWidth: screenWidth), // Use the custom footer
      );
    }

    return Scaffold(
      appBar: const CustomHeader(), // Use the custom header
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2,
              ),
              itemCount: programs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => navigateTo(context, programs[index]),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        programs[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          CustomFooter(screenWidth: screenWidth), // Use the custom footer
        ],
      ),
    );
  }
}