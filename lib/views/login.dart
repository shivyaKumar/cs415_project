import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import the MVVM ViewModel for login. This file contains the business logic for the login process.
import '../viewmodels/login_viewmodel.dart';
// Import a reusable footer widget to avoid code duplication across screens.
import 'widgets/custom_footer.dart';

/// A reusable widget that displays a label and a corresponding text field.
/// This widget helps avoid repeating similar code for input fields.
class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;

  // Constructor for the LabeledTextField widget.
  // It uses named parameters, where `label` and `controller` are required.
  // The parameter `obscureText` defaults to false if not provided.
  const LabeledTextField({
    Key? key, 
    required this.label, 
    required this.controller, 
    this.obscureText = false, 
  }) : super(key: key); 

  // The build method describes the widget's UI.
  @override
  Widget build(BuildContext context) {
    // Use a Row to horizontally arrange the label and the text field.
    return Row(
      children: [
        // SizedBox constrains the width of the label.
        SizedBox(
          width: 110, // Fixed width for the label.
          child: Text(
            label, // Display the label text.
            style: const TextStyle(fontSize: 16), // Apply a constant text style.
          ),
        ),
        // SizedBox adds horizontal spacing between the label and text field.
        const SizedBox(width: 8),
        // Expanded makes the text field take up the remaining horizontal space.
        Expanded(
          child: TextField(
            controller: controller, // Connects the text field to its controller.
            obscureText: obscureText, // Hides text if set to true (for passwords).
            decoration: const InputDecoration(
              // Adds an outlined border around the text field.
              border: OutlineInputBorder(),
              // Makes the input decoration more compact.
              isDense: true,
              // Sets the inner padding of the text field.
              contentPadding: EdgeInsets.all(5),
            ),
          ),
        ),
      ],
    );
  }
}

/// The Login view displays the login form and delegates login logic to the ViewModel.
/// This widget is stateful because it needs to track user input and manage interactions.
class Login extends StatefulWidget {
  // Constructor for Login widget.
  const Login({Key? key}) : super(key: key);

  // Creates the mutable state for this widget.
  @override
  State<Login> createState() => _LoginState();
}

// Private State class for the Login widget.
class _LoginState extends State<Login> {
  // Controller for the student email input field.
  final _studentIdController = TextEditingController();
  // Controller for the password input field.
  final _passwordController = TextEditingController();

  /// Handles the login process:
  /// - Retrieves and trims the input from text fields.
  /// - Delegates email validation and login logic to the LoginViewModel.
  /// - Navigates to the homepage upon successful login.
  void _handleLogin() async {
    // Get the trimmed email from the student ID controller.
    final email = _studentIdController.text.trim();
    // Get the password from the password controller.
    final password = _passwordController.text;

    // Retrieve the LoginViewModel instance using Provider.
    // This follows the Dependency Inversion Principle by relying on an abstraction.
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    // Validate the email using the ViewModel's logic.
    // This demonstrates the Single Responsibility Principle by delegating validation.
    if (!loginViewModel.validateEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid Student Email. Format must be sXXXXXXXX@student.usp.ac.fj',
          ),
        ),
      );
      // Exit the function if email is not valid.
      return;
    }

    // Call the login method from the ViewModel.
    // The login method encapsulates business logic (e.g., API calls).
    final firstName = await loginViewModel.login(email, password);

    // Navigate to the homepage on successful login.
    Navigator.pushReplacementNamed(context, '/homepage', arguments: firstName);
  }

  // The build method describes how to display this widget.
  @override
  Widget build(BuildContext context) {
    // Retrieve the screen width using MediaQuery for responsive layout design.
    double screenWidth = MediaQuery.of(context).size.width;
    const Color headerTeal = Color(0xFF009999);

    // Scaffold provides the basic structure of the page (AppBar, body, etc.).
    return Scaffold(
      // Define the AppBar (header) for the page.
      appBar: AppBar(
        toolbarHeight: 110, // Set the height of the app bar.
        automaticallyImplyLeading: false, // Disable the default back button.
        flexibleSpace: Image.asset(
          'assets/images/header.png', // Display a header image from assets.
          fit: BoxFit.fill, // Ensure the image fills the available space.
        ),
      ),
      // The body of the page is a Column that arranges its children vertically.
      body: Column(
        children: [
          // Expanded allows the login form area to fill the remaining vertical space.
          Expanded(
            child: SingleChildScrollView(
              // Center the login form horizontally.
              child: Center(
                // Use a Column to arrange the login form elements vertically.
                child: Column(
                  // mainAxisSize.min makes the column size itself based on its children.
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Add vertical spacing before the welcome text.
                    const SizedBox(height: 24),
                    // Display the welcome message.
                    const Text(
                      'Welcome to the USP Student Enrolment Services',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center, // Center-align the text.
                    ),
                    // Add vertical spacing after the welcome message.
                    const SizedBox(height: 24),
                    // Card widget provides a material design card for the login form.
                    Card(
                      elevation: 10, // Adds a shadow effect.
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners.
                      ),
                      // Container to set dimensions and padding for the card's content.
                      child: Container(
                        width: 350, // Fixed width for the login form.
                        padding: const EdgeInsets.all(16.0), // Uniform padding inside the container.
                        child: Column(
                          children: [
                            // Use the reusable LabeledTextField widget for the email input.
                            LabeledTextField(
                              label: 'Student Email:', // Label text.
                              controller: _studentIdController, // Controller for the email field.
                            ),
                            // Add vertical spacing between the input fields.
                            const SizedBox(height: 16),
                            // Use the reusable LabeledTextField widget for the password input.
                            LabeledTextField(
                              label: 'Password:', // Label text.
                              controller: _passwordController, // Controller for the password field.
                              obscureText: true, // Hide the password text.
                            ),
                            // Add vertical spacing before the login button.
                            const SizedBox(height: 24),
                            // SizedBox to set a fixed width for the login button.
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                // Set the function to be executed when the button is pressed.
                                onPressed: _handleLogin,
                                // Style the button with a custom background color and padding.
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: headerTeal,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                // Set the text of the button.
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(color: Colors.white), // White text color.
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Add vertical spacing after the card.
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          // Include a reusable footer widget at the bottom of the screen.
          CustomFooter(screenWidth: screenWidth),
        ],
      ),
    );
  }
}
