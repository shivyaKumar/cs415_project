import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'homepage.dart';
import 'theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'USP Student Management',
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              brightness: Brightness.light, // Light mode
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark, // Dark mode
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => Login(
                    isDarkMode: themeProvider.isDarkMode,
                    onThemeToggle: themeProvider.toggleTheme,
                  ),
              '/homepage': (context) => const Homepage(),
            },
          );
        },
      ),
    );
  }
}
