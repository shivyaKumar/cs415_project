import 'package:firebase_core/firebase_core.dart'; // Firebase core
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import 'models/student/program_level_model.dart';
// Import services
import 'theme_provider.dart';
import 'view/SASmanager/homeSAS.dart';

// Import all views used in the application
import 'view/SASstaff/homeStaff.dart';
import 'view/SASstaff/registerST.dart';
import 'view/SAdminPages/RemoveStaff.dart';
import 'view/SAdminPages/SAdminHome.dart';
import 'view/student/course_selection_page.dart';
import 'view/student/enrollment_page.dart';
import 'view/student/finance.dart';
import 'view/student/homepage.dart';
import 'view/student/solass.dart';
import 'view/student/solass.dart';
import 'view/student/stemp.dart';
import 'view/student/studentprofile.dart';
import 'view/SASstaff/editST.dart';
import 'view/student/safe.dart';
import 'view/student/sbm.dart';
import 'view/student/space.dart';
import 'view/student/sageons.dart';

// Import all ViewModel (state management) classes
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/registrationStatus_viewmodel.dart';
import 'viewmodels/sAdmin/SASManage_viewmodel.dart';
import 'viewmodels/sAdmin/removeStaff_viewmodel.dart';
import 'viewmodels/sAdmin/superAdmin_viewmodel.dart';
import 'viewmodels/student/course_enrollment_viewmodel.dart';
import 'viewmodels/student/finance_viewmodel.dart';
import 'viewmodels/student/homepage_viewmodel.dart';
import 'viewmodels/student/profile_viewmodel.dart';
import 'viewmodels/SASStaff/homeStaff_viewmodel.dart';
import 'viewmodels/SASStaff/registerStudent-viewmodel.dart';
import 'viewmodels/SASStaff/editST_viewmodel.dart';
import 'xml_loader.dart'; // Import xml_loader for XML data upload

// Firebase Configuration - Actual Configuration
const Map<String, String> firebaseConfig = {
  "apiKey": "AIzaSyAqNcdEutj09zcVnCc6QrbrQXXJ2MqX9-0",
  "authDomain": "usp-enrollment-system-database.firebaseapp.com",
  "databaseURL": "https://usp-enrollment-system-database-default-rtdb.firebaseio.com",
  "projectId": "usp-enrollment-system-database",
  "storageBucket": "usp-enrollment-system-database.appspot.com",
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

  // Upload XML data to Firebase
  final uploadResult = await XmlUploader.uploadAllXmlData();
  print(uploadResult); // Log the result of the XML upload

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
        ChangeNotifierProvider(create: (_) => HomeStaffViewModel()), // SAS Staff Dashboard state
        ChangeNotifierProvider(create: (_) => RegisterStudentViewModel()), // Register Student state
        ChangeNotifierProvider(create: (_) => SuperAdminDashboardViewModel()), // Super Admin Dashboard state
        ChangeNotifierProvider(create: (_) => EditStudentViewModel()), // Edit Student state
        ChangeNotifierProvider(create: (_) => SASManageViewModel()), // SAS Manager state
        ChangeNotifierProxyProvider<SASManageViewModel, RemoveStaffViewModel>(
          create: (_) => RemoveStaffViewModel(manageViewModel: SASManageViewModel()),
          update: (_, sasManageViewModel, __) => RemoveStaffViewModel(manageViewModel: sasManageViewModel),
        ),
      ],
      child: MyApp(
        stempProgramLevels: [], // Pass empty or actual data
        solassProgramLevels: [], // Pass empty or actual data
        sageonsProgramLevels: [],
        safeProgramLevels: [],
        spaceProgramLevels: [],
        sbmProgramLevels: []
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<ProgramLevel> stempProgramLevels;
  final List<ProgramLevel> solassProgramLevels;
  final List<ProgramLevel> sageonsProgramLevels;
  final List<ProgramLevel> safeProgramLevels;
  final List<ProgramLevel> spaceProgramLevels;
  final List<ProgramLevel> sbmProgramLevels;

  const MyApp({
    super.key,
    required this.stempProgramLevels,
    required this.solassProgramLevels,
    required this.safeProgramLevels,
    required this.sageonsProgramLevels,
    required this.sbmProgramLevels,
    required this.spaceProgramLevels,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
          final args = ModalRoute.of(context)?.settings.arguments;
          final studentId = (args is String) ? args : 'Guest';
          return Homepage(studentId: studentId);
        },
        '/profile': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final studentId = (args is String) ? args : 'Guest';
          debugPrint("Navigating to Profile with student ID: $studentId");
          return Profile(studentId: studentId); // Pass the studentId to the Profile widget
        },// Student profile page
        '/finance': (context) => const FinancePage(), // Finance summary page
        '/homeSAS': (context) => const SasManagerDashboard(), // SAS Manager Dashboard
        '/homeSA': (context) => const SuperAdminDashboard(), // Super Admin Dashboard
        '/removestaff': (context) => RemoveStaffPage(), // Remove Staff page
        '/homeStaff': (context) => ChangeNotifierProvider(
          create: (_) => HomeStaffViewModel(),
          child: HomeStaff(),
        ), // SAS Staff Dashboard
        '/course_selection': (context) => CourseSelectionPage(),// Course selection page
        '/enrollment': (context) => EnrollmentPage(), // Enrollment page
        '/stemp': (context) => StempPage(programLevels: stempProgramLevels), // STEMP page
        '/solass': (context) => SolassPage(programLevels: solassProgramLevels), // SoLaSS page
        '/registerStudent': (context) => RegisterStudentPage(), // Register student page
        '/editStudent': (context) => EditStudentPage(), // Edit student page
        '/sageons': (context) => SageonsPage(programLevels: sageonsProgramLevels), // SAGEONS page
        '/safe': (context) => SafePage(programLevels: safeProgramLevels),
        '/sbm': (context) => SbmPage(programLevels: sbmProgramLevels),
        '/space': (context) => SpacePage(programLevels: spaceProgramLevels),
      },
    );
  }
}