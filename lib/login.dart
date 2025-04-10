import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../view/student/homepage.dart';
import 'theme_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _handleLogin() async {
    debugPrint("Login button pressed");

    final id = _idController.text.trim();
    final password = _passwordController.text.trim();

    if (id.isEmpty || password.isEmpty) {
      debugPrint("ID or password is empty");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email/ID and password cannot be empty.'),
        ),
      );
      return;
    }

    // Updated regex for student email validation
    final emailRegex = RegExp(r'^[Ss]\d{6,8}@student\.usp\.ac\.fj$');
    if (!emailRegex.hasMatch(id)) {
      debugPrint("Invalid email format: $id");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email format. Please use a valid student email.'),
        ),
      );
      return;
    }

    // Extract student ID from email
    final studentId = id.split('@')[0];
    debugPrint("Extracted student ID: $studentId");

    try {
      // Fetch student data from Firebase
      debugPrint("Attempting to fetch student data from Firebase");
      final database = FirebaseDatabase.instance.ref("students");
      final snapshot = await database.child(studentId).get();

      if (snapshot.exists) {
        final student = snapshot.value as Map<dynamic, dynamic>;
        final storedPassword = student['password'] as String;

        debugPrint("Stored password: $storedPassword");
        debugPrint("Entered password: $password");

        if (password == storedPassword) {
          debugPrint("Login successful for student: $studentId");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Homepage(studentId: studentId),
            ),
          );
        } else {
          debugPrint("Invalid password for student: $studentId");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid password. Please try again.'),
            ),
          );
        }
      } else {
        debugPrint("Student ID not found in the database: $studentId");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student ID not found. Please check your credentials.'),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error fetching student data from Firebase: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error validating login: $e'),
        ),
      );
    }
  }

  Future<void> openLink(String urlString) async {
    debugPrint('Attempt to open: $urlString');
    // Implement link opening logic if required.
  }

  Widget buildFooter(double screenWidth) {
    final double scaleFactor = screenWidth < 600 ? screenWidth / 600 : 1.0;
    final double footerFontSize = 14 * scaleFactor;
    final double verticalPadding = 8 * scaleFactor;
    final double horizontalPadding = 16 * scaleFactor;
    final double logoWidth = 133 * scaleFactor;
    final double logoHeight = 60 * scaleFactor;

    return Container(
      width: double.infinity,
      color: const Color(0xFF009999),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => openLink('https://www.example.com/copyright'),
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
                      onTap: () => openLink('https://www.example.com/contact'),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Image.asset(
          'assets/images/header.png',
          fit: BoxFit.fill,
        ),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome to the USP Student Enrollment Services',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        width: 350,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 110,
                                  child: Text(
                                    'Email or ID:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _idController,
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
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: const EdgeInsets.all(10),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
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
          buildFooter(screenWidth),
        ],
      ),
    );
  }
}