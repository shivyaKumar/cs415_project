import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/login.dart';
import 'views/homepage.dart';
import 'views/studentprofile.dart';
import 'views/course_enrollment.dart';

import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/homepage_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/course_enrollment_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Inject all controllers into the widget tree.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => HomepageViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => CourseEnrollmentController()),
      ],
      child: MaterialApp(
        title: 'USP Student Management',
        theme: ThemeData(primarySwatch: Colors.indigo),
        initialRoute: '/',
        routes: {
          '/': (context) => const Login(),
          '/login': (context) => const Login(),
          '/homepage': (context) {
            final args = ModalRoute.of(context)!.settings.arguments;
            final username = (args is String) ? args : 'Guest';
            return Homepage(username: username);
          },
          '/profile': (context) => const Profile(),
          '/myEnrollment': (context) => const CourseEnrolmentPage(),
          // Add additional routes if needed.
        },
      ),
    );
  }
}
