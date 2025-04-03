import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import all views used in the application
import 'view/staff/homeStaff.dart';
import 'view/SAdminPages/SASManage.dart';
import 'view/student/stemp.dart';
import 'view/SAdminPages/SAdminHome.dart';
import 'view/SAS/homeSAS.dart';
import 'view/student/homepage.dart';
import 'login.dart';
import 'view/student/studentprofile.dart';
import 'view/student/course_selection_page.dart';
import 'view/student/enrollment_page.dart';
import 'view/staff/registerST.dart';
import 'models/program_level_model.dart';
import 'view/student/sageons.dart';
import 'view/student/finance.dart';

// Import all ViewModel (state management) classes
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/homepage_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/course_enrollment_viewmodel.dart';
import 'viewmodels/finance_viewmodel.dart';
import 'viewmodels/registrationStatus_viewmodel.dart';

// Import services
import 'services/xml_parser.dart';
import 'theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load program levels from XML files
  List<ProgramLevel> programLevels = await loadProgramLevels('assets/SAGEONS_2.xml');
  List<ProgramLevel> programLevels1 = await loadProgramLevels('assets/STEMP.xml');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Theme state
        ChangeNotifierProvider(create: (_) => LoginViewModel()), // Login page state
        ChangeNotifierProvider(create: (_) => HomepageViewModel()), // Homepage state
        ChangeNotifierProvider(create: (_) => ProfileController()), // Student profile state
        ChangeNotifierProvider(create: (_) => CourseEnrollmentViewModel()), // Course enrollment state
        ChangeNotifierProvider(create: (_) => FinancePageViewModel()), // Finance page state
        ChangeNotifierProvider(create: (_) => RegistrationStatusViewModel()), // Registration status state
      ],
      child: MyApp(
        programLevels: programLevels,
        programLevels1: programLevels1,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<ProgramLevel> programLevels;
  final List<ProgramLevel> programLevels1;

  const MyApp({
    super.key,
    required this.programLevels,
    required this.programLevels1,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'USP Student Management',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),

      // Initial screen shown when app starts
      initialRoute: '/',

      // Named routes used for navigation throughout the app
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
        '/finance': (context) => const FinancePage(), // Finance summary page
        '/homeSAS': (context) => const SasManagerDashboard(), // SAS Manager Dashboard
        '/homeSA': (context) => const SuperAdminDashboard(), // Super Admin Dashboard
        '/sas_manage': (context) => const SASManage(), // SAS Manage page
        '/homeStaff': (context) => HomeStaff(), // SAS Staff Dashboard
        '/course_selection': (context) => CourseSelectionPage(), // Course selection page
        '/enrollment': (context) => EnrollmentPage(), // Enrollment page
        '/sageons': (context) => SageonsPage(programLevels: programLevels), // Sageons page
        '/stemp': (context) => StempPage(programLevels: programLevels1), // STEMP page
        '/registerStudent': (context) => RegisterStudentPage(), // Register student page
      },
    );
  }
}