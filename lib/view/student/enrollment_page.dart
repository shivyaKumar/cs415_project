import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/course_enrollment_viewmodel.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';

class EnrollmentPage extends StatefulWidget {
  const EnrollmentPage({super.key});

  @override
  _EnrollmentPageState createState() => _EnrollmentPageState();
}

class _EnrollmentPageState extends State<EnrollmentPage> {
  @override
  void initState() {
    super.initState();
    // Load enrolled courses when the page is initialized
    Future.microtask(() =>
        Provider.of<CourseEnrollmentViewModel>(context, listen: false)
            .loadEnrolledCourses());
  }

  @override
  Widget build(BuildContext context) {
    // Access the ViewModel using Provider
    final viewModel = Provider.of<CourseEnrollmentViewModel>(context);

    // Get screen width to adjust layout responsively
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomHeader(),
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
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/course_selection'); // Navigate to course selection page
              },
              child: const Text('Go to Course Selection'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: viewModel.enrolledCourses.isEmpty
                  ? const Center(
                      child: Text(
                        "No courses enrolled yet.",
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: viewModel.enrolledCourses.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: const Icon(Icons.book, color: Colors.blue),
                            title: Text(
                              viewModel.enrolledCourses[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomFooter(screenWidth: screenWidth), // Pass screenWidth to CustomFooter
    );
  }
}