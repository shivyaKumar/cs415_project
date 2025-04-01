import 'package:flutter/material.dart';
import 'widgets/custom_header.dart';
import 'widgets/custom_footer.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final Color navbarBlue = const Color.fromARGB(255, 8, 45, 87);
  final int maxCoursesAllowed = 4;

  final List<String> availableCourses = []; // Placeholder
  final List<String> selectedCourses = [];

  void _toggleCourse(String course) {
    setState(() {
      if (selectedCourses.contains(course)) {
        selectedCourses.remove(course);
      } else if (selectedCourses.length < maxCoursesAllowed) {
        selectedCourses.add(course);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMaxedOut = selectedCourses.length >= maxCoursesAllowed;

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
                            margin: const EdgeInsets.all(5),
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    color: navbarBlue,
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Course Selection Per Semester',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'You are only allowed to enroll in a maximum of $maxCoursesAllowed course(s).',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'You have selected ${selectedCourses.length} course(s).',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  if (isMaxedOut)
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      color: Colors.red.shade100,
                                      child: const Text(
                                        'You have already selected the maximum number of courses.',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Tap to select a course:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  if (availableCourses.isEmpty)
                                    const Text(
                                      'No courses available to display.',
                                      style: TextStyle(fontStyle: FontStyle.italic),
                                    )
                                  else
                                    ...availableCourses.map((course) {
                                      final isSelected = selectedCourses.contains(course);
                                      final isSelectable = !isSelected && !isMaxedOut;

                                      return ListTile(
                                        title: Text(course),
                                        trailing: isSelected
                                            ? const Icon(Icons.check_circle, color: Colors.green)
                                            : null,
                                        enabled: isSelected || isSelectable,
                                        onTap: () => _toggleCourse(course),
                                      );
                                    }),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: selectedCourses.isEmpty ? null : () {
                                      // Save logic will go here later
                                    },
                                    child: const Text("Save Selection"),
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
}
