import 'package:flutter/material.dart';

// Reusable header and footer widgets (SRP, DIP)
import 'widgets/custom_header.dart';
import 'widgets/custom_footer.dart';
import 'addcourse.dart';

/// Main CourseEnrolmentPage widget.
/// Uses a view (stateful widget) that delegates building parts of the UI
/// to smaller, self-contained widgets.
class CourseEnrolmentPage extends StatefulWidget {
  const CourseEnrolmentPage({Key? key}) : super(key: key);

  @override
  State<CourseEnrolmentPage> createState() => _CourseEnrolmentPageState();
}

class _CourseEnrolmentPageState extends State<CourseEnrolmentPage> {
  // Data
  final List<String> semesters = ["Semester I, 2025", "Semester II, 2025"];
  int selectedSemesterIndex = 0;
  final List<String> activeRegistrations = [];
  final List<String> droppedRegistrations = [];

  // Colors used in the page (could be provided via a Theme or Config)
  final Color navbarBlue = const Color.fromARGB(255, 8, 45, 87);
  final Color tealBar = const Color(0xFF009999);

  /// Handler for Add Course button.
  Future<void> _onAddCourse() async {
    debugPrint("Add Course button pressed");

     // Navigate to the AddCoursePage
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AddCoursePage(),
    ),
  );
}

  /// Changes the selected semester.
  void _updateSelectedSemester(int index) {
    setState(() {
      selectedSemesterIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final String currentSemester = semesters[selectedSemesterIndex];

    return Scaffold(
      // Reusable header demonstrating SRP and DIP.
      appBar: const CustomHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
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
                    // Main content is split into self-contained widgets (SRP).
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Enrollment Dashboard header.
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
                        // Hero section: shows image with semester selection.
                        HeroSection(
                          imagePath: 'assets/images/student.png',
                          height: 250,
                          semesters: semesters,
                          selectedIndex: selectedSemesterIndex,
                          onSemesterSelected: _updateSelectedSemester,
                        ),
                        const SizedBox(height: 16.0),
                        // Online Enrollment bar.
                        OnlineEnrollmentBar(
                          semesterLabel: currentSemester,
                          backgroundColor: navbarBlue,
                        ),
                        // Active Registrations section.
                        RegistrationSection(
                          title: 'Current Enrollments',
                          items: activeRegistrations,
                          emptyMessage:
                              'You are not currently enrolled in any courses',
                          headerColor: tealBar,
                        ),
                        // Add Course button.
                        AddCourseButton(
                          onPressed: _onAddCourse,
                          backgroundColor: tealBar,
                        ),
                        // Dropped / Not Approved Courses section.
                        RegistrationSection(
                          title: 'Dropped/ Not Approved Courses',
                          items: droppedRegistrations,
                          emptyMessage: 'No Dropped/ Unapproved Courses',
                          headerColor: tealBar,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Reusable footer (SRP)
            CustomFooter(screenWidth: screenWidth),
          ],
        ),
      ),
    );
  }
}

/// A widget that displays the hero image with an overlaid semester selection row.
/// SRP: This widget is responsible only for building the hero section.
class HeroSection extends StatelessWidget {
  final String imagePath;
  final double height;
  final List<String> semesters;
  final int selectedIndex;
  final ValueChanged<int> onSemesterSelected;

  const HeroSection({
    Key? key,
    required this.imagePath,
    required this.height,
    required this.semesters,
    required this.selectedIndex,
    required this.onSemesterSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hero image background.
        Image.asset(
          imagePath,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
        ),
        // Positioned semester selection row.
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Center(
            child: SemesterSelectionRow(
              semesters: semesters,
              selectedIndex: selectedIndex,
              onSemesterSelected: onSemesterSelected,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget that displays a row of hoverable semester selection buttons.
/// SRP: Only responsible for creating the row of buttons.
class SemesterSelectionRow extends StatelessWidget {
  final List<String> semesters;
  final int selectedIndex;
  final ValueChanged<int> onSemesterSelected;

  const SemesterSelectionRow({
    Key? key,
    required this.semesters,
    required this.selectedIndex,
    required this.onSemesterSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(semesters.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: HoverableSemesterButton(
            label: semesters[index],
            isSelected: selectedIndex == index,
            onTap: () => onSemesterSelected(index),
          ),
        );
      }),
    );
  }
}

/// A hoverable button for semester selection using a reusable hoverable widget.
/// SRP: Encapsulates button styling and hover behavior.
class HoverableSemesterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const HoverableSemesterButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double scaleFactor = screenWidth < 600 ? screenWidth / 600 : 1.0;
    final double verticalPadding = 12 * scaleFactor;
    final double horizontalPadding = 20 * scaleFactor;
    final double fontSize = 16 * scaleFactor;

    return _HoverableButton(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF009999) : Colors.white,
          foregroundColor: isSelected ? Colors.white : const Color(0xFF009999),
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
}

/// A widget for displaying the online enrollment bar.
/// SRP: Focuses on displaying the enrollment text.
class OnlineEnrollmentBar extends StatelessWidget {
  final String semesterLabel;
  final Color backgroundColor;

  const OnlineEnrollmentBar({
    Key? key,
    required this.semesterLabel,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
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
}

/// A reusable widget for showing registration sections (e.g., active or dropped courses).
/// SRP: Only responsible for building a registration section.
class RegistrationSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final String emptyMessage;
  final Color headerColor;

  const RegistrationSection({
    Key? key,
    required this.title,
    required this.items,
    required this.emptyMessage,
    required this.headerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: headerColor,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8.0),
          child: items.isEmpty
              ? Text(emptyMessage)
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) => Text(items[index]),
                ),
        ),
      ],
    );
  }
}

/// A widget that encapsulates the "Add Course" button.
/// SRP: This widget handles its own styling and behavior.
class AddCourseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;

  const AddCourseButton({
    Key? key,
    required this.onPressed,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: _HoverableButton(
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
      ),
    );
  }
}

/// A reusable hoverable widget that applies a scale animation on hover.
/// SRP: Focuses solely on the hover animation behavior.
/// DIP: Can be reused anywhere without knowledge of its internal state.
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
