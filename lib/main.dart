import 'package:flutter/material.dart';

import 'SAdminHome.dart';
import 'homeSAS.dart';
import 'homepage.dart';
import 'login.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'USP Student Management',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      // Define initial route and app routes.
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/homepage': (context) => const Homepage(),
        '/homeSAS': (context) => const SasManagerDashboard(), // Make sure HomeSAS is imported
        '/homeSA': (context) => const SuperAdminDashboard(), // Make sure HomeSA is imported
      },
    );
  }
}
