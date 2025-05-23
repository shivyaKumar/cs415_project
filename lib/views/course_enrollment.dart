// Required Flutter and Provider packages for UI and state management
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ViewModel handles business logic and data fetching (SOLID: SRP, OOP: Separation of Concerns)
import '../viewmodels/course_enrollment_viewmodel.dart';

// Data model for enrolled course (OOP: Encapsulation)
import '../models/enrolled_course.dart';

// Custom reusable widgets
import 'widgets/custom_header.dart';
import 'widgets/custom_footer.dart';
import 'addcourse.dart';

// CourseEnrolmentPage displays current and dropped courses using responsive layout
class CourseEnrolmentPage extends StatefulWidget {
  const CourseEnrolmentPage({super.key});

  @override
  State<CourseEnrolmentPage> createState() => _CourseEnrolmentPageState();
}

class _CourseEnrolmentPageState extends State<CourseEnrolmentPage> {
  final Color navbarBlue = const Color.fromARGB(255, 8, 45, 87);
  final Color sectionHeaderColor = const Color(0xFF009999);

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<CourseEnrollmentViewModel>(context, listen: false);
    viewModel.loadEnrolledCourses();
    viewModel.loadDroppedCourses();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CourseEnrollmentViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomHeader(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1040),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            elevation: 4,
                            margin: const EdgeInsets.all(5.0),
                            child: Container(
                              color: const Color(0xFFF6F0FB),
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    color: navbarBlue,
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Enrollment Dashboard',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 16 / 4,
                                    child: Image.asset(
                                      'assets/images/student.png',
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),

                                  _sectionTitle('Current Enrollments', color: sectionHeaderColor),
                                  viewModel.activeCourses.isEmpty
                                      ? const Text('You are not currently enrolled in any courses.')
                                      : _responsiveLayout(screenWidth, viewModel.activeCourses, false),

                                  const SizedBox(height: 16.0),
                                  AddCourseButton(onPressed: _onAddCourse, backgroundColor: sectionHeaderColor),
                                  const SizedBox(height: 16.0),

                                  _sectionTitle('Dropped / Not Approved Courses', color: sectionHeaderColor),
                                  viewModel.droppedCourses.isEmpty
                                      ? const Text('No Dropped / Unapproved Courses.')
                                      : _responsiveLayout(screenWidth, viewModel.droppedCourses, true),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    CustomFooter(screenWidth: screenWidth),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onAddCourse() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCoursePage()),
    );
  }

  Widget _responsiveLayout(double width, List<EnrolledCourse> courses, bool isDropped) {
    return width >= 600 ? _buildDataTable(courses, isDropped) : _buildCards(courses, isDropped);
  }

  Widget _buildDataTable(List<EnrolledCourse> data, bool isDropped) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1000,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(navbarBlue),
          headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          columns: const [
            DataColumn(label: Text("Course")),
            DataColumn(label: Text("Title")),
            DataColumn(label: Text("Campus")),
            DataColumn(label: Text("Mode")),
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Action")),
          ],
          rows: data.map((course) {
            return DataRow(cells: [
              DataCell(Text(course.code)),
              DataCell(Text(course.title)),
              DataCell(Text(course.campus)),
              DataCell(Text(course.mode)),
              DataCell(Text(course.status)),
              DataCell(
                isDropped
                    ? const Text("Dropped")
                    : ElevatedButton(
                        onPressed: () {
                          Provider.of<CourseEnrollmentViewModel>(context, listen: false).dropCourse(course);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: sectionHeaderColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Drop"),
                      ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCards(List<EnrolledCourse> courses, bool isDropped) {
    return Column(
      children: courses.map((course) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow("Course", course.code),
              _infoRow("Title", course.title),
              _infoRow("Campus", course.campus),
              _infoRow("Mode", course.mode),
              _infoRow("Status", course.status),
              const SizedBox(height: 8),
              if (!isDropped)
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<CourseEnrollmentViewModel>(context, listen: false).dropCourse(course);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sectionHeaderColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Drop"),
                  ),
                )
              else
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text("Dropped"),
                )
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, {required Color color}) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AddCourseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;

  const AddCourseButton({Key? key, required this.onPressed, required this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F0FB),
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: const StadiumBorder(),
            elevation: 8,
            shadowColor: Colors.black54,
          ),
          onPressed: onPressed,
          child: const Text('Add Course'),
        ),
      ),
    );
  }
}
