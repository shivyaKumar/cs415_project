import 'package:flutter/material.dart';

// Import SASManage.dart

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  

  // Convert map to list
  //final List<MapEntry<String, String>> sasManagerList = _sasManagers.entries.toList();

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

    //SAS Manager Login (Using List)
    if (id.toLowerCase() == "sasmanage" && password == "sasmanage") {
      Navigator.of(context).pushReplacementNamed('/homeSAS');
      return;
    }

    if (id.toLowerCase() == "sasstaff" && password == "sasstaff") {
      Navigator.of(context).pushReplacementNamed('/homeStaff');
      return;
    }

    // Student Login
    if (studentRegex.hasMatch(id) && id == "s11208719@student.usp.ac.fj" && password == "s11208719") {
      Navigator.of(context).pushReplacementNamed('/homepage');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid credentials. Please try again.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color headerTeal = Color(0xFF009999);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 110,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/header.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
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
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      child: Container(
                        width: 350,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 110, child: Text('Email or ID:', style: TextStyle(fontSize: 16))),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 110, child: Text('Password:', style: TextStyle(fontSize: 16))),
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
                                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
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
          // Footer Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: headerTeal,
            child: const Center(
              child: Text(
                '© 2025 University of the South Pacific | All rights reserved',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
