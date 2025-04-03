import 'package:cs415_project/view/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      // Add other pages when available
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$programName page is under development!')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> programs = ['SPACE', 'STEMP', 'SOLASS', 'SAGEONS', 'SAFE', 'SBM'];
    final registrationStatus = Provider.of<RegistrationStatusViewModel>(context);

    if (!registrationStatus.isRegistrationOpen) {
      return Scaffold(
        appBar: CustomHeader(),
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
        bottomNavigationBar: _buildFooter(), // Add the footer here
      );
    }

    return Scaffold(
      appBar: CustomHeader(),
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildFooter(), 
        ],
      ),
    );
  }

  Widget _buildFooter({double height = 80}) {
    return SizedBox(
      height: height,
      child: Container(
        width: double.infinity,
        color: Colors.teal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _openLink('https://www.example.com/copyright'),
                        child: const Text(
                          'Copyright',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('|', style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => _openLink('https://www.example.com/contact'),
                        child: const Text(
                          'Contact Us',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '© Copyright 1968 - 2025. All Rights Reserved.',
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
                  Text('The University of the South Pacific', style: TextStyle(color: Colors.white)),
                  Text('Laucala Campus, Suva, Fiji', style: TextStyle(color: Colors.white)),
                  Text('Tel: +679 323 1000', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openLink(String url) {
    print('Opening link: $url');
  }
}
