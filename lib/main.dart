import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'homepage.dart';
import 'studentprofile.dart';
import 'theme_provider.dart';
import 'services/xml_parser.dart';
import 'services/local_storage.dart';
import 'models/program_level_model.dart';
import 'enrollment_page.dart';
import 'course_selection_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<ProgramLevel> programLevels = await loadProgramsFromXML('assets/images/SAGEONS_2.xml');

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(programLevels: programLevels),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<ProgramLevel> programLevels;
  const MyApp({super.key, required this.programLevels});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'USP Student Management',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/homepage': (context) => const Homepage(),
        '/profile': (context) => const Profile(),
        '/course-selection': (context) => CourseSelectionPage(programLevels: programLevels),
        '/enrollment': (context) => EnrollmentPage(),
      },
    );
  }
}
