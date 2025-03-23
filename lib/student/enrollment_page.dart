import 'package:flutter/material.dart';
import '../services/local_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EnrollmentPage extends StatefulWidget {
  const EnrollmentPage({super.key});

  @override
  _EnrollmentPageState createState() => _EnrollmentPageState();
}

class _EnrollmentPageState extends State<EnrollmentPage> {
  List<String> enrolledCourses = [];

  @override
  void initState() {
    super.initState();
    loadEnrolledCourses();
  }

  /// Loads selected courses from local storage
  Future<void> loadEnrolledCourses() async {
    List<String> courses = await LocalStorage.getSelectedCourses();
    setState(() {
      enrolledCourses = courses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: AppBar(
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
            ],
          ),
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enrolled Courses",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            enrolledCourses.isEmpty
                ? const Center(
                    child: Text(
                      "No courses enrolled yet.",
                      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: enrolledCourses.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: const Icon(Icons.book, color: Colors.blue),
                            title: Text(
                              enrolledCourses[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  _buildFooter(),
          ],
        ),
      ),
    );
  }
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