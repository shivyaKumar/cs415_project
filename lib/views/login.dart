import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import the MVVM ViewModel for login.
// This file should be located in lib/viewmodels/login_viewmodel.dart
import '../viewmodels/login_viewmodel.dart';
// Import a reusable footer widget to avoid code duplication (SRP)
import 'widgets/custom_footer.dart';

/// The Login view displays the login form and delegates login logic to the ViewModel.
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers for input fields – view concerns only.
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Handles the login process:
  /// - Collects input from text fields.
  /// - Delegates email validation and login logic to the ViewModel.
  /// - Navigates to the homepage on successful login.
  void _handleLogin() async {
    final email = _studentIdController.text.trim();
    final password = _passwordController.text;
    
    // Dependency Inversion: the view depends on the abstract LoginViewModel
    // (provided via Provider) rather than a concrete implementation.
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    // Single Responsibility: email validation logic is inside the ViewModel.
    if (!loginViewModel.validateEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid Student Email. Format must be sXXXXXXXX@student.usp.ac.fj',
          ),
        ),
      );
      return;
    }

    // Business logic (e.g., API call) is encapsulated in the ViewModel.
    final firstName = await loginViewModel.login(email, password);

    // Navigation is a view concern.
    Navigator.pushReplacementNamed(context, '/homepage', arguments: firstName);
  }

  @override
  Widget build(BuildContext context) {
    // Obtain screen width to calculate responsive sizes.
    double screenWidth = MediaQuery.of(context).size.width;
    // Define a theme color for the header (used in several places)
    const Color headerTeal = Color(0xFF009999);

    return Scaffold(
      // AppBar handles header display (view only)
      appBar: AppBar(
        toolbarHeight: 110,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Image.asset(
          'assets/images/header.png',
          fit: BoxFit.fill,
        ),
      ),
      // Body is divided into main content and footer.
      body: Column(
        children: [
          // Main Content Area: Displays welcome text and the login form.
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome to the USP Student Enrolment Services',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        width: 350,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Email Input Field (View Responsibility)
                            Row(
                              children: [
                                const SizedBox(
                                  width: 110,
                                  child: Text(
                                    'Student Email:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _studentIdController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Password Input Field (View Responsibility)
                            Row(
                              children: [
                                const SizedBox(
                                  width: 110,
                                  child: Text(
                                    'Password:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // LOGIN Button: Calls _handleLogin which uses the ViewModel.
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: headerTeal,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          // Reusable Footer: Follows Single Responsibility (one footer definition for all screens)
          CustomFooter(screenWidth: screenWidth),
        ],
      ),
    );
  }
}
