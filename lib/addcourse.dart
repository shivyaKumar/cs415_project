import 'package:flutter/material.dart';

/// You can also place this WaveClipper in a separate file if you prefer.
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Start from top-left corner
    path.lineTo(0, size.height * 0.6);

    // First curve
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.7,
      size.width * 0.5, size.height * 0.6,
    );

    // Second curve
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.5,
      size.width, size.height * 0.6,
    );

    // Then line straight to the top-right corner
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => false;
}

/// Model for each year's courses
class YearCourses {
  final String title;
  final List<String> courses;
  YearCourses({required this.title, required this.courses});
}

class AddCoursePage extends StatefulWidget {
  final String program;            // e.g., "Bachelor of Software Engineering"
  final int maxSelectableCourses;  // e.g., 5

  const AddCoursePage({
    Key? key,
    required this.program,
    this.maxSelectableCourses = 5,
  }) : super(key: key);

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  // Example data: expansions for each "Year" in a program
  final List<YearCourses> _years = [
    YearCourses(
      title: "Bachelor of Software Engineering Year 1",
      courses: [
        "SE101 - Intro to Software Engineering",
        "SE102 - Programming Fundamentals",
        "SE103 - Discrete Mathematics",
      ],
    ),
    YearCourses(
      title: "Bachelor of Software Engineering Year 2",
      courses: [
        "SE201 - Data Structures",
        "SE202 - Algorithms",
        "SE203 - Software Design",
      ],
    ),
    YearCourses(
      title: "Bachelor of Software Engineering Year 3",
      courses: [
        "SE301 - Database Systems",
        "SE302 - Operating Systems",
        "SE303 - Software Testing",
      ],
    ),
  ];

  // Tracks which expansions are open
  final List<bool> _expanded = [];

  // Tracks user’s selected courses
  final Set<String> _selectedCourses = {};

  // Colors to match your wireframe
  final Color purpleBar = const Color.fromARGB(255, 8, 45, 87);
  final Color tealBar = const Color(0xFF009999);

  @override
  void initState() {
    super.initState();
    // Initialize expansions to be all closed
    _expanded.addAll(List.generate(_years.length, (_) => false));
  }

  @override
  Widget build(BuildContext context) {
    final int maxAllowed = widget.maxSelectableCourses;

    return Scaffold(
      // No appBar, so we can mimic the same style as your main page
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header image (same as main page)
            SizedBox(
              height: 110,
              width: double.infinity,
              child: Image.asset(
                'assets/images/header.png',
                fit: BoxFit.fill,
              ),
            ),
            // Wave background
            Stack(
              children: [
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: 400, // Adjust as needed to show wave
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 183, 213, 213),
                          Color(0xFF4DD0E1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                // Centered Card with expansions
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1040),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header text
                            Text(
                              "Online Registration - ${widget.program}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Course Selection Per Program",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Info text about maximum courses
                            Text(
                              "You are only allowed to enroll in a maximum of $maxAllowed course(s).\n"
                              "Your current registrations indicate how many you've already enrolled in.\n"
                              "Therefore you can only select up to $maxAllowed course(s).",
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 16),

                            // The expansions
                            _buildExpansionPanels(),

                            const SizedBox(height: 16),
                            // Accept & Confirm button
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: tealBar,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: _onConfirm,
                                child:
                                    const Text("Accept & Confirm Enrollment"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the list of expansions for each "year"
  Widget _buildExpansionPanels() {
    return ListView.builder(
      shrinkWrap: true, // So it doesn't try to take infinite height
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _years.length,
      itemBuilder: (context, index) {
        final yearData = _years[index];
        final isOpen = _expanded[index];
        return Card(
          child: ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                _expanded[index] = !isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text(yearData.title),
                  );
                },
                body: Column(
                  children: yearData.courses.map((course) {
                    final isSelected = _selectedCourses.contains(course);
                    return CheckboxListTile(
                      title: Text(course),
                      value: isSelected,
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true &&
                              _selectedCourses.length >=
                                  widget.maxSelectableCourses) {
                            // Show a warning if user tries to exceed max
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Maximum ${widget.maxSelectableCourses} courses allowed.",
                                ),
                              ),
                            );
                          } else {
                            // Toggle selection
                            if (checked == true) {
                              _selectedCourses.add(course);
                            } else {
                              _selectedCourses.remove(course);
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                isExpanded: isOpen,
              ),
            ],
          ),
        );
      },
    );
  }

  /// When user taps "Accept & Confirm," return selected courses
  void _onConfirm() {
    // Convert the set to a list
    final chosen = _selectedCourses.toList();
    Navigator.pop(context, chosen);
  }
}
