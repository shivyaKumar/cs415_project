import 'package:cs415_project/SAS/homeStaff.dart';
import 'package:cs415_project/SAdminPages/SASManage.dart';
import 'package:cs415_project/student/stemp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cs415_project/theme_provider.dart';

import 'SAdminPages/SAdminHome.dart';
import 'SAS/homeSAS.dart';
import 'student/homepage.dart';
import 'login.dart';
import 'student/studentprofile.dart';
import 'student/course_selection_page.dart';
import 'student/enrollment_page.dart';
import 'services/xml_parser.dart';
import 'models/program_level_model.dart';
import 'student/sageons.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  List<ProgramLevel> programLevels = await loadProgramsFromXML('assets/SAGEONS_2.xml',);
  List<ProgramLevel> programLevels1 = await loadProgramsFromXML('assets/STEMP.xml',);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(
        programLevels: programLevels,
        programLevels1: programLevels1
        ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<ProgramLevel> programLevels;
  final List<ProgramLevel> programLevels1;
  const MyApp({super.key, required this.programLevels, required this.programLevels1});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'USP Student Management',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      // Define initial route and app routes.
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/homepage': (context) => const Homepage(),
        '/homeSAS': (context) => const SasManagerDashboard(), // Make sure HomeSAS is imported
        '/homeSA': (context) => const SuperAdminDashboard(), // Make sure HomeSA is imported
        '/sas_manage': (context) => const SASManage(), // Make sure SASManage is imported
        '/homeStaff': (context) => HomeStaff(),  // Make sure HomeStaff is imported
        '/profile': (context) => Profile(),
        '/course_selection': (context) => CourseSelectionPage(),
        '/enrollment': (context) => EnrollmentPage(),
        '/sageons': (context) => SageonsPage(programLevels: programLevels),
        '/stemp': (context) => StempPage(programLevels: programLevels1)
      },
    );
  }
}
