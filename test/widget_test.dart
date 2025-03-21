import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cs415_project/main.dart'; // Import your main file
import 'package:cs415_project/models/program_level_model.dart'; // Import ProgramLevel model
import 'package:cs415_project/models/program_model.dart'; // Import Program model
import 'package:cs415_project/models/course_model.dart'; // Import Course model
import 'package:cs415_project/models/year_model.dart'; // Import Year model

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create a list of Course objects
    List<Course> courses = [
      Course(code: 'CS101', name: 'Intro to Computer Science'),
      Course(code: 'CS102', name: 'Data Structures', prerequisites: ['CS101']),
    ];

    // Create a list of Year objects
    List<Year> years = [
      Year(yearNumber: 1, courses: courses),
      Year(yearNumber: 2, courses: courses),
    ];

    // Create a list of Program objects with the 'years' parameter
    List<Program> programs = [
      Program(name: 'Computer Science', years: years),
      Program(name: 'Information Technology', years: years),
    ];

    // Create a list of ProgramLevel objects with the 'programs' parameter
    List<ProgramLevel> programLevels = [
      ProgramLevel(name: 'Undergraduate', programs: programs),
      ProgramLevel(name: 'Postgraduate', programs: programs),
    ];

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(programLevels: programLevels));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
