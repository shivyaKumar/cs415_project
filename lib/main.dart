import 'package:cs415_project/SAS/homeStaff.dart';
import 'package:cs415_project/SAdminPages/SASManage.dart';
import 'package:flutter/material.dart';

import 'SAdminPages/SAdminHome.dart';
import 'SAS/homeSAS.dart';
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
        '/sas_manage': (context) => const SASManage(), // Make sure SASManage is imported
        '/homeStaff': (context) => HomeStaff(),  // Make sure HomeStaff is imported
      },
    );
  }
}
