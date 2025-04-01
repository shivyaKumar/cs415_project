import 'package:flutter/material.dart';
import 'widgets/custom_header.dart';
import 'widgets/custom_footer.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  // Use the same blue color from the Enrollment page
  final Color navbarBlue = const Color.fromARGB(255, 8, 45, 87);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // Same custom header as your Enrollment page
      appBar: const CustomHeader(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              // Ensures the column fills at least the viewport height
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // The card is centered and constrained just like in Enrollment
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1040),
                          child: Card(
                            // Same shape, elevation, margin, and padding as Enrollment
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            elevation: 4,
                            margin: const EdgeInsets.all(5.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Dark blue header inside the card
                                  Container(
                                    color: navbarBlue,
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Courses/ Prerequisites',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  // Placeholder text for course details
                                  const Text(
                                    'This is the page for courses and prerequisites. '
                                    'Display course details, prerequisites, and other related information here.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Same custom footer as your Enrollment page
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
