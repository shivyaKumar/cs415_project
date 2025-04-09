import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'global.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _handleLogin() {
    final id = _idController.text.trim();
    final password = _passwordController.text.trim();

    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email textbox cannot be empty.'),
        ),
      );
      return;
    }

    final studentRegex = RegExp(r'^[Ss][0-9]{8}@student\.usp\.ac\.fj$');

    // Super Admin Login
    if (id.toLowerCase() == "superadmin" && password == "superadmin123") {
      Navigator.of(context).pushReplacementNamed('/homeSA');
      return;
    }

    // SAS Manager Login
    if (id == "SA1110122" && password == "sasmanage1") {
      Navigator.of(context).pushReplacementNamed('/homeSAS');
      return;
    } else if (id == "SA1120121" && password == "sasmanage2") {
      Navigator.of(context).pushReplacementNamed('/homeSAS');
      return;
    }

    // SAS Staff Login
    if (id.toLowerCase() == "SS1064925" && password == "sasstaff1") {
      Navigator.of(context).pushReplacementNamed('/homeStaff');
      return;
    }
    else if (id.toLowerCase() == "SS10565294" && password == "sasstaff2") {
      Navigator.of(context).pushReplacementNamed('/homeStaff');
      return;
    }

    // Student Login (must match regex & have password 12345)
    if (studentRegex.hasMatch(id) && password == "12345") {
      debugPrint('Login successful for student: $id');
      loggedInEmails.add(id);
      Navigator.pushReplacementNamed(context, '/homepage');
      return;
    }

    // Invalid credentials
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid credentials. Please try again.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    const Color headerTeal = Color(0xFF009999);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
        automaticallyImplyLeading: false,
        flexibleSpace: Image.asset(
          'assets/images/header.png',
          fit: BoxFit.fill,
        ),
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
                                  child: Text(
                                    'Password:',
                                    style: TextStyle(fontSize: 16),
                                  ),
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
          _buildFooter(screenWidth: screenWidth),
        ],
      ),
    );
  }

  Widget _buildFooter({double screenWidth = 0}) {
    return SizedBox(
      height: 80,
      child: Container(
        width: double.infinity,
        color: Colors.teal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
    );
  }

  void _openLink(String url) {
    print('Opening link: $url');
  }
}