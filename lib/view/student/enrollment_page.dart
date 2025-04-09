import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/student/course_enrollment_viewmodel.dart';
import 'widgets/custom_header.dart';
import 'widgets/custom_footer.dart';
import '../../models/student/enrolled_course_model.dart';

class EnrollmentPage extends StatefulWidget {
  const EnrollmentPage({super.key});

  @override
  _EnrollmentPageState createState() => _EnrollmentPageState();
}

class _EnrollmentPageState extends State<EnrollmentPage> {
  final Color navbarBlue = const Color.fromARGB(255, 8, 45, 87);
  final Color sectionHeaderColor = const Color(0xFF009999);
  List<Map<String, String>> selectedCourses = [];
  List<Map<String, String>> droppedCourses = [];

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<CourseEnrollmentViewModel>(context, listen: false);
    viewModel.loadEnrolledCourses();
    viewModel.loadDroppedCourses();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Load selected courses from arguments
    final args = ModalRoute.of(context)?.settings.arguments as List<Map<String, String>>?;
    if (args != null && selectedCourses.isEmpty) {
      setState(() {
        selectedCourses = args;
      });
    }
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
                                  // Conditionally render the table or the text
                                if (selectedCourses.isNotEmpty)
                                  _buildSelectedCoursesTable()
                                else
                                  const Text(
                                    'You are not currently enrolled in any courses.',
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16.0),
                                  AddCourseButton(onPressed: _onAddCourse, backgroundColor: sectionHeaderColor),
                                  const SizedBox(height: 16.0),

                                  _sectionTitle('Dropped / Not Approved Courses', color: sectionHeaderColor),
                                  if (droppedCourses.isNotEmpty)
                                    _buildDroppedCoursesList()
                                  else
                                    const Text(
                                      'No Dropped Courses.',
                                      style: TextStyle(fontSize: 16, color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  
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


  Widget _buildSelectedCoursesTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width, // Make the table responsive
        ),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(navbarBlue),
          headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          columns: const [
            DataColumn(label: Text("Course")),
            DataColumn(label: Text("Title")),
            DataColumn(label: Text("Campus")),
            DataColumn(label: Text("Action")),
          ],
          rows: selectedCourses.map((course) {
            return DataRow(cells: [
              DataCell(Text(course['code'] ?? 'N/A')),
              DataCell(Text(course['title'] ?? 'N/A')),
              DataCell(Text(course['campus'] ?? 'N/A')),
              DataCell(
                ElevatedButton(
                  onPressed: () {
                    _deregisterCourse(course);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
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

  void _deregisterCourse(Map<String, String> course) {
    setState(() {
      selectedCourses.remove(course);
      droppedCourses.add({
        'code': course['code'] ?? 'N/A',
        'title': course['title'] ?? 'N/A',
        'status': 'Dropped',
      });
    });
  }

  Widget _buildDroppedCoursesList() {
    if (droppedCourses.isEmpty) {
      return const Text(
        'No Dropped / Unapproved Courses.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: droppedCourses.map((course) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            '${course['code']} - ${course['title']} - ${course['status']}',
            style: const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
    );
  }

  void _onAddCourse() {
    Navigator.pushNamed(context, '/course_selection'); // Navigate to course selection page
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

  const AddCourseButton({super.key, required this.onPressed, required this.backgroundColor});

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