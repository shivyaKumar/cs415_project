import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;

import '../models/course_model.dart';
import '../models/program_level_model.dart';
import '../models/program_model.dart';
import '../models/year_model.dart';

Future<List<ProgramLevel>> loadProgramsFromXML(String filePath) async {
  try {
    final String xmlString = await rootBundle.loadString(filePath);
    final xml.XmlDocument document = xml.XmlDocument.parse(xmlString);

    List<ProgramLevel> programLevels = [];

    for (var levelNode in document.findAllElements('programLevel')) {
      String levelName = levelNode.getAttribute('name') ?? "Unknown Level";
      List<Program> programs = [];
      List<String> allUnits = []; // Store unit codes for filtering later

      for (var programNode in levelNode.findAllElements('program')) {
        String programName = programNode.getAttribute('name') ?? "Unknown Program";
        List<Year> years = [];

        for (var yearNode in programNode.findAllElements('year')) {
          int yearNumber = int.tryParse(yearNode.getAttribute('number') ?? '0') ?? 0;
          List<Course> courses = [];

          for (var courseNode in yearNode.findAllElements('course')) {
            String courseCode = courseNode.getAttribute('code') ?? "";
            String courseName = courseNode.getAttribute('name') ?? "";

            List<String> prerequisites = courseNode
                .findElements('prerequisite')
                .map((p) => p.getAttribute('code') ?? "")
                .where((p) => p.isNotEmpty)
                .toList();

            courses.add(Course(code: courseCode, name: courseName, prerequisites: prerequisites));

            // Collect unit codes for later filtering
            if (courseCode.isNotEmpty) {
              allUnits.add(courseCode);
            }
          }
          years.add(Year(yearNumber: yearNumber, courses: courses));
        }
        programs.add(Program(name: programName, years: years));
      }
      programLevels.add(ProgramLevel(name: levelName, programs: programs));
    }

    return programLevels;
  } catch (e) {
    print("Error parsing XML: $e");
    return [];
  }
}
