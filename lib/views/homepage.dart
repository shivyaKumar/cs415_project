import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/homepage_viewmodel.dart';
import 'widgets/custom_footer.dart';
import 'widgets/custom_header.dart'; // Reusable header widget to avoid code duplication (SRP)

/// The Homepage widget displays the main dashboard after a user logs in.
/// It uses a HomepageViewModel for business logic and various helper methods
/// to build parts of the UI, keeping styling and layout separated.
class Homepage extends StatelessWidget {
  /// The username passed from the login screen used to greet the user.
  final String username;

  /// Constructor for the Homepage widget.
  const Homepage({super.key, required this.username});

  // ─────────────────────────────────────────────────────────────────────────────
  // Button Style for the "Enroll Now" button.
  // This method encapsulates styling logic for dynamic button states.
  // It uses WidgetStateProperty to change properties like background color
  // and elevation when hovered or pressed, following the Single Responsibility Principle (SRP).
  // ─────────────────────────────────────────────────────────────────────────────
  ButtonStyle _enrollButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        // When the button is hovered, change to a lighter blue.
        if (states.contains(WidgetState.hovered)) {
          return const Color.fromARGB(255, 10, 60, 100);
        }
        // When the button is pressed, change to a slightly darker blue with transparency.
        if (states.contains(WidgetState.pressed)) {
          return const Color.fromARGB(255, 8, 45, 87).withAlpha(204);
        }
        // Default background color.
        return const Color.fromARGB(255, 8, 45, 87);
      }),
      elevation: WidgetStateProperty.resolveWith<double>((states) {
        // Increase elevation when hovered.
        if (states.contains(WidgetState.hovered)) return 8;
        // Remove elevation when pressed.
        if (states.contains(WidgetState.pressed)) return 0;
        // Default elevation.
        return 2;
      }),
      // Set constant foreground (text) color.
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      // Set padding for the button.
      padding: WidgetStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      // Define the shape of the button.
      shape: WidgetStateProperty.all<OutlinedBorder>(
        const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Button Style for the "View Courses" button.
  // This follows the same approach as _enrollButtonStyle, ensuring consistency
  // and reusability in the styling of buttons.
  // ─────────────────────────────────────────────────────────────────────────────
  ButtonStyle _viewProgramsButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        // Change background color on hover.
        if (states.contains(WidgetState.hovered)) return Colors.grey.shade300;
        // Change background color on press.
        if (states.contains(WidgetState.pressed)) return Colors.grey.shade400;
        // Default background color.
        return Colors.white;
      }),
      elevation: WidgetStateProperty.resolveWith<double>((states) {
        // Increase elevation on hover.
        if (states.contains(WidgetState.hovered)) return 8;
        // Remove elevation on press.
        if (states.contains(WidgetState.pressed)) return 0;
        // Default elevation.
        return 2;
      }),
      // Set constant text color.
      foregroundColor: WidgetStateProperty.all<Color>(Colors.black87),
      // Set padding.
      padding: WidgetStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      // Define the shape of the button.
      shape: WidgetStateProperty.all<OutlinedBorder>(
        const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Helper method to build a feature tile for the homepage grid.
  // This method encapsulates the logic for creating a tile with an icon,
  // label, and tap behavior. It follows SRP by handling one responsibility.
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildFeatureTile({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF083057), // Dark background color for the tile.
      elevation: 4, // Elevation gives a shadow effect.
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap, // Executes the onTap callback when the tile is tapped.
        hoverColor: Colors.blueGrey.withAlpha(51), // Hover effect color.
        splashColor: Colors.blue.withAlpha(51),    // Splash effect color on tap.
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon displayed on the tile.
                Icon(icon, size: 70, color: Colors.white),
                const SizedBox(height: 12),
                // Label text for the tile.
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve screen width to determine layout (e.g., grid column count).
    final double screenWidth = MediaQuery.of(context).size.width;

    // ─────────────────────────────────────────────────────────────────────────────
    // Dependency Inversion Principle (DIP):
    // Retrieve the HomepageViewModel via Provider.
    // The UI depends on an abstraction rather than a concrete implementation.
    // ─────────────────────────────────────────────────────────────────────────────
    final homepageViewModel = Provider.of<HomepageViewModel>(context);

    // Update the ViewModel's username with the passed username.
    homepageViewModel.username = username;

    return Scaffold(
      // ─────────────────────────────────────────────────────────────────────────────
      // CustomHeader widget is used for the AppBar,
      // following SRP by encapsulating header logic in its own widget.
      // ─────────────────────────────────────────────────────────────────────────────
      appBar: const CustomHeader(),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─────────────────────────────────────────────────────────────────────────────
            // Hero Section:
            // A Stack is used to place overlay content on top of the background image.
            // The background image uses BoxFit.cover to fill the space, and the overlay
            // container applies a semi-transparent black color to darken the image.
            // ─────────────────────────────────────────────────────────────────────────────
            Stack(
              children: [
                // Background image for the hero section.
                Image.asset(
                  'assets/images/homepage.png',
                  width: double.infinity, // Fills the available width.
                  height: 350, // Fixed height for the hero image.
                  fit: BoxFit.cover, // Ensures the image covers the entire area.
                ),
                // Overlay container to darken the image and display text/buttons.
                Container(
                  width: double.infinity,
                  height: 350,
                  color: Colors.black.withAlpha(77), // Semi-transparent overlay.
                  alignment: Alignment.center, // Center the content.
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Wrap content tightly.
                      children: [
                        // Main title text.
                        const Text(
                          'Welcome to USP Student Services',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        // Subtitle text.
                        const Text(
                          'Your one-stop hub for enrollment, course management,\nacademic success.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // Row containing the two main action buttons.
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // "Enroll Now" button with its style encapsulated in _enrollButtonStyle.
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to the My Enrollment page.
                                Navigator.pushNamed(context, '/myEnrollment');
                              },
                              style: _enrollButtonStyle(),
                              child: const Text(
                                'Enroll Now',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // "View Courses" button with its style encapsulated in _viewProgramsButtonStyle.
                            ElevatedButton(
                              onPressed: () =>
                                  debugPrint('View Courses tapped'),
                              style: _viewProgramsButtonStyle(),
                              child: const Text(
                                'View Courses',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20), // Spacing between hero and grid.

            // ─────────────────────────────────────────────────────────────────────────────
            // Feature Tiles Section:
            // A grid of feature tiles (shortcuts) for navigation.
            // Uses GridView.count for a simple grid layout.
            // The reusable _buildFeatureTile method creates each tile.
            // ─────────────────────────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                // Determines the number of columns based on screen width.
                crossAxisCount: screenWidth < 600 ? 2 : 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true, // Let the grid occupy only the needed space.
                physics: const NeverScrollableScrollPhysics(), // Prevent scrolling within the grid.
                children: [
                  _buildFeatureTile(
                    label: 'My Profile',
                    icon: Icons.person,
                    onTap: () => Navigator.pushNamed(context, '/profile'),
                  ),
                  _buildFeatureTile(
                    label: 'My Enrollment',
                    icon: Icons.how_to_reg,
                    onTap: () => Navigator.pushNamed(context, '/myEnrollment'),
                  ),
                  _buildFeatureTile(
                    label: 'Courses',
                    icon: Icons.menu_book,
                    onTap: () => debugPrint('Courses tapped'),
                  ),
                  _buildFeatureTile(
                    label: 'Finance',
                    icon: Icons.attach_money,
                    onTap: () => debugPrint('Finance tapped'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20), // Spacing between grid and footer.

            // ─────────────────────────────────────────────────────────────────────────────
            // Footer Section:
            // The CustomFooter widget encapsulates footer logic,
            // ensuring consistency and reuse across pages.
            // ─────────────────────────────────────────────────────────────────────────────
            CustomFooter(screenWidth: screenWidth),
          ],
        ),
      ),
    );
  }
}
