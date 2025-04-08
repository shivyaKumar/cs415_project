import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import all views used in the application
import 'view/SASstaff/homeStaff.dart';
import 'view/SAdminPages/SASManage.dart';
import 'view/student/stemp.dart';
import 'view/SAdminPages/SAdminHome.dart';
import 'view/SASmanager/homeSAS.dart';
import 'view/student/homepage.dart';
import 'login.dart';
import 'view/student/studentprofile.dart';
import 'view/student/course_selection_page.dart';
import 'view/student/enrollment_page.dart';
import 'view/SASstaff/registerST.dart';
import 'models/student/program_level_model.dart';
import 'view/student/solass.dart';
import 'view/student/finance.dart';

// Import all ViewModel (state management) classes
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/student/homepage_viewmodel.dart';
import 'viewmodels/student/profile_viewmodel.dart';
import 'viewmodels/student/course_enrollment_viewmodel.dart';
import 'viewmodels/student/finance_viewmodel.dart';
import 'viewmodels/registrationStatus_viewmodel.dart';

// Import services
import 'services/xml_parser.dart';
import 'theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load program levels from XML files for STEMP and SoLaSS
  List<ProgramLevel> stempProgramLevels = await loadProgramLevels('STEMP', 'programLevels.xml');
  List<ProgramLevel> solassProgramLevels = await loadProgramLevels('SOLASS', 'programLevels.xml');

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
        stempProgramLevels: stempProgramLevels,
        solassProgramLevels: solassProgramLevels,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<ProgramLevel> stempProgramLevels;
  final List<ProgramLevel> solassProgramLevels;

  const MyApp({
    super.key,
    required this.stempProgramLevels,
    required this.solassProgramLevels,
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
        '/stemp': (context) => StempPage(programLevels: stempProgramLevels), // STEMP page
        '/solass': (context) => SolassPage(programLevels: solassProgramLevels), // SoLaSS page
        '/registerStudent': (context) => RegisterStudentPage(), // Register student page
      },
    );
  }
}