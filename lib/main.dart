import 'package:cs415_project/fees_and_holds_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase core
import 'package:firebase_database/firebase_database.dart'; // Firebase Realtime Database
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'xml_loader.dart'; // Your XML loader
import 'student_registration_page.dart';

import 'login.dart';
import 'homepage.dart';
import 'studentprofile.dart';
import 'course_selection_page.dart';
import 'enrollment_page.dart';
import 'xml_screen.dart'; // Importing the XmlUploadScreen

// Firebase Configuration - Actual Configuration
const Map<String, String> firebaseConfig = {
  "apiKey": "AIzaSyAqNcdEutj09zcVnCc6QrbrQXXJ2MqX9-0",
  "authDomain": "usp-enrollment-system-database.firebaseapp.com",
  "databaseURL": "https://usp-enrollment-system-database-default-rtdb.firebaseio.com",
  "projectId": "usp-enrollment-system-database",
  "storageBucket": "usp-enrollment-system-database.firebasestorage.app",
  "messagingSenderId": "862102884770",
  "appId": "1:862102884770:web:4c7a4328441831f16fe2fb",
  "measurementId": "G-RR0N7ZMH2D"
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase manually with the actual configuration
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: firebaseConfig['apiKey']!,
      authDomain: firebaseConfig['authDomain']!,
      databaseURL: firebaseConfig['databaseURL']!,
      projectId: firebaseConfig['projectId']!,
      storageBucket: firebaseConfig['storageBucket']!,
      messagingSenderId: firebaseConfig['messagingSenderId']!,
      appId: firebaseConfig['appId']!,
      measurementId: firebaseConfig['measurementId']!,
    ),
  );

  // Run the app with XmlUploadScreen as the first screen
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'USP Student Management',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/fees-and-holds', // Start at the register screen
      //initialRoute: '/register', // Start at the register screen
      //initialRoute: '/upload-xml', use this to upload data 
      ///fees-and-holds
      routes: {
        '/': (context) => const Login(),
        '/homepage': (context) => const Homepage(),
        '/profile': (context) => const Profile(),
        '/fees-and-holds': (context) => FeesAndHoldsPage(studentId: 'S001'), // Default student ID
        //'/course-selection': (context) => const CourseSelectionPage(),
        '/register': (context) => const StudentRegistrationPage(),
        '/enrollment': (context) => const EnrollmentPage(),
        '/upload-xml': (context) => const XmlLoaderScreen(), // XML upload screen
      },
    );
  }
}