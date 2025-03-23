import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'addcourse.dart'; // <-- Import your AddCourse file

class CourseEnrolmentPage extends StatefulWidget {
  const CourseEnrolmentPage({Key? key}) : super(key: key);

  @override
  State<CourseEnrolmentPage> createState() => _CourseEnrolmentPageState();
}

class _CourseEnrolmentPageState extends State<CourseEnrolmentPage> {
  // Simulated data (replace with DB or API data later)
  final String studentId = "S11286803";
  final String studentName = "Shivya Sunandta Kumar";
  final String program = "Bachelor of Software Engineering";

  // Example semesters
  final List<String> semesters = ["Semester I, 2025", "Semester II, 2025"];
  int selectedSemesterIndex = 0;

  // Enrollment lists
  final List<String> activeRegistrations = [];
  final List<String> droppedRegistrations = [];

  // Colors
  static const Color headerTeal = Color(0xFF009999);
  static const Color navbarBlue = Color.fromARGB(255, 8, 45, 87);
  final Color purpleBar = const Color.fromARGB(255, 8, 45, 87);
  final Color tealBar = const Color(0xFF009999);

  // Stub for link opening
  Future<void> _openLink(String urlString) async {
    debugPrint('Attempt to open: $urlString');
    // Implement url_launcher or other link-opening logic here
  }

  /// Called when user taps "Add Course" button
  Future<void> _onAddCourse() async {
    final selectedCourses = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddCoursePage(
          program: program,
          maxSelectableCourses: 5,
        ),
      ),
    );
    if (selectedCourses != null && selectedCourses.isNotEmpty) {
      setState(() {
        activeRegistrations.addAll(selectedCourses);
      });
    }
  }

  /// Build one hoverable ElevatedButton for a given semester
  Widget _buildHoverButton(String label, bool isSelected, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double scaleFactor = screenWidth < 600 ? screenWidth / 600 : 1.0;

    final double verticalPadding = 12 * scaleFactor;
    final double horizontalPadding = 20 * scaleFactor;
    final double fontSize = 16 * scaleFactor;

    return _HoverableButton(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? tealBar : Colors.white,
          foregroundColor: isSelected ? Colors.white : tealBar,
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          shape: const StadiumBorder(),
          elevation: 8,
          shadowColor: Colors.black54,
          textStyle: TextStyle(fontSize: fontSize),
        ),
        icon: isSelected ? const Icon(Icons.check) : const SizedBox.shrink(),
        label: Text(label),
        onPressed: onTap,
      ),
    );
  }

  /// Row of semester buttons
  Widget _buildSemesterSelectionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(semesters.length, (index) {
        final bool isSelected = (selectedSemesterIndex == index);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _buildHoverButton(
            semesters[index],
            isSelected,
            () {
              setState(() {
                selectedSemesterIndex = index;
              });
            },
          ),
        );
      }),
    );
  }

  /// Footer 
  Widget buildFooter(double screenWidth) {
    final double scaleFactor = screenWidth < 600 ? screenWidth / 600 : 1.0;
    final double footerFontSize = 14 * scaleFactor;
    final double verticalPadding = 8 * scaleFactor;
    final double horizontalPadding = 16 * scaleFactor;
    final double logoWidth = 133 * scaleFactor;
    final double logoHeight = 60 * scaleFactor;

    return Container(
      width: double.infinity,
      color: headerTeal,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => _openLink('https://www.example.com/copyright'),
                      child: Text(
                        'Copyright',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontSize: footerFontSize,
                        ),
                      ),
                    ),
                    SizedBox(width: 8 * scaleFactor),
                    Text(
                      '|',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: footerFontSize,
                      ),
                    ),
                    SizedBox(width: 8 * scaleFactor),
                    InkWell(
                      onTap: () => _openLink('https://www.example.com/contact'),
                      child: Text(
                        'Contact Us',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontSize: footerFontSize,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4 * scaleFactor),
                Text(
                  '© Copyright 1968 - 2025. '
                  'All Rights Reserved.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: footerFontSize,
                  ),
                ),
              ],
            ),
          ),
          // Center column (Logo)
          Expanded(
            child: Center(
              child: SvgPicture.asset(
                'assets/images/usp_logo.svg',
                width: logoWidth,
                height: logoHeight,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Right column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'The University of the South Pacific',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: footerFontSize,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  'Laucala Campus, Suva, Fiji',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: footerFontSize,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  'Tel: +679 323 1000',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: footerFontSize,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Online Registration bar
  Widget _buildOnlineRegistrationSection() {
    final semesterLabel = semesters[selectedSemesterIndex];
    return Container(
      color: purpleBar,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Online Enrollment - $semesterLabel',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Active Registrations section
  Widget _buildActiveRegistrationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: tealBar,
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Current Enrollments',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8.0),
          child: activeRegistrations.isEmpty
              ? const Text('You are not currently enrolled in any courses')
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activeRegistrations.length,
                  itemBuilder: (context, index) =>
                      Text(activeRegistrations[index]),
                ),
        ),
      ],
    );
  }

  /// Add Course button with hover effect
  Widget _buildAddCourseButton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: _HoverableButton(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: tealBar,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              shape: const StadiumBorder(),
              elevation: 8,
              shadowColor: Colors.black54,
            ),
            onPressed: _onAddCourse,
            child: const Text('Add Course'),
          ),
        ),
      ),
    );
  }

  /// Dropped/ Not Approved Registrations section
  Widget _buildDroppedNotApprovedRegistrationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: tealBar,
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Dropped/ Not Approved Courses',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8.0),
          child: droppedRegistrations.isEmpty
              ? const Text('No Dropped/ Unapproved Courses')
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: droppedRegistrations.length,
                  itemBuilder: (context, index) =>
                      Text(droppedRegistrations[index]),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Scaffold(
      // NEW: Replacing the old header image with the same AppBar as in Profile
      appBar: AppBar(
        backgroundColor: headerTeal,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: SvgPicture.asset(
            'assets/images/usp_logo.svg',
            height: 70,
            width: 90,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(0, kToolbarHeight),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  Navigator.pushNamed(context, '/profile');
                  break;
                case 'myEnrollment':
                  // We are on the enrollment page, do nothing or reload
                  break;
                case 'courses':
                  Navigator.pushNamed(context, '/courses');
                  break;
                case 'finance':
                  Navigator.pushNamed(context, '/finance');
                  break;
                case 'logout':
                  // Example logout
                  Navigator.pushReplacementNamed(context, '/login');
                  break;
              }
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.person, size: 32, color: Colors.white),
            ),
            itemBuilder: (context) => [
              // The "Hi, Student" line
              PopupMenuItem<String>(
                enabled: false,
                child: Text('Hi, Student'),
              ),
              const PopupMenuDivider(),

              // Profile
              PopupMenuItem<String>(
                value: 'profile',
                child: Container(
                  color: (currentRoute == '/profile') ? navbarBlue : null,
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: (currentRoute == '/profile')
                          ? Colors.white
                          : Colors.black,
                    ),
                    title: Text(
                      'Profile',
                      style: TextStyle(
                        color: (currentRoute == '/profile')
                            ? Colors.white
                            : Colors.black,
                        fontWeight: (currentRoute == '/profile')
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),

              // My Enrollment
              PopupMenuItem<String>(
                value: 'myEnrollment',
                child: Container(
                  color: (currentRoute == '/myEnrollment') ? navbarBlue : null,
                  child: ListTile(
                    leading: Icon(
                      Icons.how_to_reg,
                      color: (currentRoute == '/myEnrollment')
                          ? Colors.white
                          : Colors.black,
                    ),
                    title: Text(
                      'My Enrollment',
                      style: TextStyle(
                        color: (currentRoute == '/myEnrollment')
                            ? Colors.white
                            : Colors.black,
                        fontWeight: (currentRoute == '/myEnrollment')
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),

              // Courses
              PopupMenuItem<String>(
                value: 'courses',
                child: Container(
                  color: (currentRoute == '/courses') ? navbarBlue : null,
                  child: ListTile(
                    leading: Icon(
                      Icons.menu_book,
                      color: (currentRoute == '/courses')
                          ? Colors.white
                          : Colors.black,
                    ),
                    title: Text(
                      'Courses',
                      style: TextStyle(
                        color: (currentRoute == '/courses')
                            ? Colors.white
                            : Colors.black,
                        fontWeight: (currentRoute == '/courses')
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),

              // Finance
              PopupMenuItem<String>(
                value: 'finance',
                child: Container(
                  color: (currentRoute == '/finance') ? navbarBlue : null,
                  child: ListTile(
                    leading: Icon(
                      Icons.attach_money,
                      color: (currentRoute == '/finance')
                          ? Colors.white
                          : Colors.black,
                    ),
                    title: Text(
                      'Finance',
                      style: TextStyle(
                        color: (currentRoute == '/finance')
                            ? Colors.white
                            : Colors.black,
                        fontWeight: (currentRoute == '/finance')
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),

              const PopupMenuDivider(),

              // Logout
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),

      // MAIN CONTENT with pinned footer
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              // Force the total height to be at least the screen height
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // MAIN CONTENT
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1040),
                          child: Card(
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
                                  // Course Enrollment title
                                  Container(
                                    color: purpleBar,
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text(
                                      'Enrollment Dashboard',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // Student image with semester buttons
                                  Stack(
                                    children: [
                                      Image.asset(
                                        'assets/images/student.png',
                                        width: double.infinity,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 16,
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: _buildSemesterSelectionRow(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),

                                  // Online Registration
                                  _buildOnlineRegistrationSection(),
                                  // Active Registrations
                                  _buildActiveRegistrationsSection(),
                                  // Add Course button
                                  _buildAddCourseButton(),
                                  // Dropped / Not Approved
                                  _buildDroppedNotApprovedRegistrationsSection(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // FOOTER
                    buildFooter(screenWidth),
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

/// Hoverable button for desktop (no effect on mobile)
class _HoverableButton extends StatefulWidget {
  final Widget child;
  const _HoverableButton({Key? key, required this.child}) : super(key: key);

  @override
  State<_HoverableButton> createState() => _HoverableButtonState();
}

class _HoverableButtonState extends State<_HoverableButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: isHovered ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
