import 'package:flutter/material.dart';
import 'login.dart';
import 'homepage.dart';
import 'studentprofile.dart';
import 'course_enrolment.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/login': (context) => const Login(),

        // Use a fallback if `args` is null or not a String
        '/homepage': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final username = (args is String) ? args : 'Guest';
          return Homepage(username: username);
        },

        '/profile': (context) => const Profile(),
        '/myEnrollment': (context) => const CourseEnrolmentPage(),
      },
    );
  }
}
