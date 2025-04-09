import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/registrationStatus_viewmodel.dart';
import 'widgets/custom_header.dart';
import 'widgets/custom_footer.dart';

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
    final double screenWidth = MediaQuery.of(context).size.width;
    final List<String> programs = [
      'SPACE',
      'STEMP',
      'SOLASS',
      'SAGEONS',
      'SAFE',
      'SBM',
    ];
    final registrationStatus = Provider.of<RegistrationStatusViewModel>(context);

    if (!registrationStatus.isRegistrationOpen) {
      return Scaffold(
        appBar: const CustomHeader(),
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
                Navigator.pushNamed(context, '/enrollment');
              },
              child: const Text('View Enrolled Courses'),
            ),
          ],
        ),
        bottomNavigationBar: CustomFooter(screenWidth: screenWidth),
      );
    }

    return Scaffold(
      appBar: const CustomHeader(),
      backgroundColor: Colors.indigo[50],
      body: Center( // Center the tiles on the page
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 16.0, // Horizontal spacing between tiles
            runSpacing: 16.0, // Vertical spacing between tiles
            children: programs.map((program) {
              return GestureDetector(
                onTap: () => navigateTo(context, program),
                child: Container(
                  width: 150, // Fixed width for each tile
                  height: 150, // Fixed height for square tiles
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF08305D), // Navy blue color
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      program,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      bottomNavigationBar: CustomFooter(screenWidth: screenWidth),
    );
  }
}