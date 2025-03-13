import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const Login({super.key, required this.isDarkMode, required this.onThemeToggle});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() {
    final email = _studentIdController.text.trim();
    final emailRegex = RegExp(r'^[Ss][0-9]{8}@student\.usp\.ac\.fj$');

    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Student Email. Format: sXXXXXXXX@student.usp.ac.fj'),
        ),
      );
      return;
    }

    debugPrint('Login pressed with valid email: $email');
    Navigator.pushReplacementNamed(context, '/homepage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ─── Header Image ───
          SizedBox(
            height: 110,
            width: double.infinity,
            child: Image.asset('assets/images/header.png', fit: BoxFit.cover),
          ),

          // ─── Welcome Message & Dark Mode Toggle ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              children: [
                // Spacer to push the text to center
                const Spacer(),

                // Welcome Message
                const Text(
                  'Welcome to the Student Enrolment Services',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),

                // Spacer pushes the switch to the right end
                const Spacer(),

                // Dark Mode Toggle Switch
                Switch(
                  value: widget.isDarkMode,
                  onChanged: (value) => widget.onThemeToggle(),
                ),
              ],
            ),
          ),

          // ─── Login Form ───
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Login Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      child: Container(
                        width: 350,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Student Email
                            Row(
                              children: [
                                const SizedBox(
                                  width: 110,
                                  child: Text('Student Email:', style: TextStyle(fontSize: 16)),
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

                            // Password
                            Row(
                              children: [
                                const SizedBox(
                                  width: 110,
                                  child: Text('Password:', style: TextStyle(fontSize: 16)),
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
                                  backgroundColor: const Color(0xFF009999),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('LOGIN', style: TextStyle(color: Colors.white)),
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

          // ─── Footer ───
          Container(
            width: double.infinity,
            color: const Color(0xFF009999),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => _openLink('https://www.example.com/copyright'),
                            child: const Text(
                              'Copyright',
                              style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('|', style: TextStyle(color: Colors.white)),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => _openLink('https://www.example.com/contact'),
                            child: const Text(
                              'Contact Us',
                              style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text('© 1968 - 2025. All Rights Reserved.', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),

                // Center (Logo)
                Expanded(
                  child: Center(
                    child: SvgPicture.asset('assets/images/usp_logo.svg', width: 133, height: 60, fit: BoxFit.contain),
                  ),
                ),

                // Right Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text('The University of the South Pacific', style: TextStyle(color: Colors.white)),
                      Text('Laucala Campus, Suva, Fiji', style: TextStyle(color: Colors.white)),
                      Text('Tel: +679 323 1000', style: TextStyle(color: Colors.white)),
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

  Future<void> _openLink(String urlString) async {
    debugPrint('Attempt to open: $urlString');
  }
}
