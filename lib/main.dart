import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import all views used in the application
import 'views/login.dart';
import 'views/homepage.dart';
import 'views/studentprofile.dart';
import 'views/course_enrollment.dart';
import 'views/addcourse.dart';
import 'views/courses.dart';
import 'views/finance.dart';

// Import all ViewModel (state management) classes
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/homepage_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/course_enrollment_viewmodel.dart';
import 'viewmodels/finance_viewmodel.dart'; 

void main() {
  runApp(const MyApp()); // Entry point of the application
}

/// Root widget of the application (Stateless as it doesn't manage state internally)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider allows injection of multiple ChangeNotifierProviders
    // This adheres to the Dependency Inversion Principle (DIP) from SOLID
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()), // Login page state
        ChangeNotifierProvider(create: (_) => HomepageViewModel()), // Homepage state
        ChangeNotifierProvider(create: (_) => ProfileController()), // Student profile state
        ChangeNotifierProvider(create: (_) => CourseEnrollmentViewModel()),
        ChangeNotifierProvider(create: (_) => FinancePageViewModel()), // Finance page state
      ],
      child: MaterialApp(
        title: 'USP Student Management',
        theme: ThemeData(primarySwatch: Colors.indigo),

        // Initial screen shown when app starts
        initialRoute: '/',

        // Named routes used for navigation throughout the app
        // This helps integrate browser back/forward button support on Flutter web
        routes: {
          '/': (context) => const Login(), // Default route to login
          '/login': (context) => const Login(),
          '/homepage': (context) {
            // Retrieves arguments passed to the homepage (such as username)
            final args = ModalRoute.of(context)!.settings.arguments;
            final username = (args is String) ? args : 'Guest';
            return Homepage(username: username);
          },
          '/profile': (context) => const Profile(), // Student profile page
          '/myEnrollment': (context) => const CourseEnrolmentPage(), // Course enrollment page
          '/addCourse': (context) => const AddCoursePage(), // Add new course page
          '/finance': (context) => const FinancePage(), // Finance summary page
          '/courses': (context) => const CoursesPage(), // View all available courses
          // Add more routes here if new pages are created
        },
      ),
    );
  }
}
