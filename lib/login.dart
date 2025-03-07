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

  void _handleLogin() {
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
    Navigator.pushReplacementNamed(context, '/homepage');
  }

  Future<void> _openLink(String urlString) async {
    debugPrint('Attempt to open: $urlString');
  }

  @override
  Widget build(BuildContext context) {
    // The color matching your header/footer theme
    const Color headerTeal = Color(0xFF009999);
        // Get the screen height and width
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Column(
        children: [
          // ────────── TOP HEADER WITH BACKGROUND IMAGE ──────────
                  // Header Container
        SizedBox(
          height: 110, // 30% of the screen height
          width: screenWidth, // Set width to screen width
          child: Image.asset(
            'assets/images/header.png', // Replace with your image
            fit: BoxFit.fill, // Ensures the image covers the entire container
          ),
        ),
/*          SizedBox(
            height: 110, // Adjust height as needed
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/header.png', // Your header image
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),*/

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

          // ────────── BOTTOM FOOTER ──────────
          Container(
            width: double.infinity,
            color: headerTeal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left column (Expanded)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Copyright / Contact row
                      Row(
                        children: [
                          InkWell(
                            onTap: () => _openLink('https://www.example.com/copyright'),
                            child: const Text(
                              'Copyright',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('|', style: TextStyle(color: Colors.white)),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => _openLink('https://www.example.com/contact'),
                            child: const Text(
                              'Contact Us',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '© Copyright 1968 - 2025. All Rights Reserved.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // Center column (SVG logo)
                Expanded(
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/usp_logo.svg',
                      width: 133,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Right column (Expanded)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        'The University of the South Pacific',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Laucala Campus, Suva, Fiji',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Tel: +679 323 1000',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}