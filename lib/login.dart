import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();

  // Dummy function to simulate fetching a user profile
  Future<String> fetchUserFirstName(String email) async {
    // Simulate a delay (like an API call)
    await Future.delayed(const Duration(seconds: 1));
    // Return a default name (replace with real logic later)
    return "Student";
  }

  void _handleLogin() async {
    final email = _studentIdController.text.trim();

    // Regex: one "S" or "s", exactly 8 digits, then "@student.usp.ac.fj"
    final emailRegex = RegExp(r'^[Ss][0-9]{8}@student\.usp\.ac\.fj$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid Student Email. Format must be sXXXXXXXX@student.usp.ac.fj',
          ),
        ),
      );
      return;
    }

    debugPrint('Login pressed with valid email: $email');

    // Simulate fetching the user's first name (no database yet)
    final firstName = await fetchUserFirstName(email);

    // Navigate to Homepage passing the first name
    Navigator.pushReplacementNamed(
      context,
      '/homepage',
      arguments: firstName,
    );
  }

  Future<void> _openLink(String urlString) async {
    debugPrint('Attempt to open: $urlString');
    // Implement link opening logic (e.g., using url_launcher)
  }

  /// Builds a responsive footer that scales font size, padding, and logo dimensions.
  Widget buildFooter(double screenWidth) {
    const Color headerTeal = Color(0xFF009999);
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
                      onTap: () =>
                          _openLink('https://www.example.com/copyright'),
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
                      onTap: () =>
                          _openLink('https://www.example.com/contact'),
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
                  '© Copyright 1968 - 2025. All Rights Reserved.',
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

  @override
  Widget build(BuildContext context) {
    const Color headerTeal = Color(0xFF009999);
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Image.asset(
          'assets/images/header.png', // Your USP header image
          fit: BoxFit.fill,
        ),
      ),
      body: Column(
        children: [
          // ────────── MIDDLE CONTENT ──────────
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),
                    // Welcome Text
                    const Text(
                      'Welcome to the USP Student Enrolment Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // White Card for Login
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
                            // Student Email Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                            // Password Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                            // LOGIN BUTTON
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
                    // Forgot Password? (centered)
                    Container(
                      width: 320,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextButton(
                        onPressed: () {
                          debugPrint('Forgot Password? pressed');
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          // ────────── RESPONSIVE FOOTER ──────────
          buildFooter(screenWidth),
        ],
      ),
    );
  }
}
