import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  static Future<void> saveSelectedCourses(List<String> selectedCourses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_courses', jsonEncode(selectedCourses));
  }

  static Future<List<String>> getSelectedCourses() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('selected_courses');
    return List<String>.from(jsonDecode(data!));
  }
}
