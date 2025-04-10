import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;

import '../models/student/course_model.dart';
import '../models/student/program_level_model.dart';
import '../models/student/program_model.dart';
import '../models/student/year_model.dart';
// Import the CourseAvailability model

/// Load courses from the courseTypes.xml file
Future<List<Course>> loadCourses(String fileName) async {
  try {
    final String filePath = 'assets/XMLs/$fileName'; // Updated path
    final String xmlString = await rootBundle.loadString(filePath);
    final xml.XmlDocument document = xml.XmlDocument.parse(xmlString);

    return document.findAllElements('course').map((courseNode) {
      final courseCode = courseNode.getAttribute('code') ?? '';
      final courseName = courseNode.getAttribute('courseName') ?? '';
      final semType = courseNode.getAttribute('sem_type')?.toLowerCase() == 'true';
      final prerequisitesString = courseNode.getAttribute('prerequisities') ?? '';
      final prerequisites = prerequisitesString.isNotEmpty
          ? prerequisitesString.split(',')
          : <String>[];

      return Course(
        code: courseCode,
        name: courseName,
        prerequisites: prerequisites,
        type: semType ? "full" : "half",
      );
    }).toList();
  } catch (e) {
    print("Error parsing courses XML: $e");
    return [];
  }
}

/// Load prerequisites from the prerequisites.xml file
Future<Map<String, List<String>>> loadPrerequisites(String folder, String fileName) async {
  try {
    final String filePath = 'assets/$folder/$fileName';
    final String xmlString = await rootBundle.loadString(filePath);
    final xml.XmlDocument document = xml.XmlDocument.parse(xmlString);

    final prerequisites = <String, List<String>>{};
    for (final element in document.findAllElements('prerequisite')) {
      final courseCode = element.getAttribute('courseCode') ?? '';
      final prereqList = element.getAttribute('prereqs')?.split(',') ?? [];
      prerequisites[courseCode] = prereqList;
    }
    return prerequisites;
  } catch (e) {
    print("Error parsing prerequisites XML: $e");
    return {};
  }
}

/// Load program levels from the programLevels.xml file
Future<List<ProgramLevel>> loadProgramLevels(String folder, String fileName) async {
  try {
    final String filePath = 'assets/$folder/$fileName';
    final String xmlString = await rootBundle.loadString(filePath);
    final xml.XmlDocument document = xml.XmlDocument.parse(xmlString);

    return document.findAllElements('programLevel').map((levelNode) {
      final levelName = levelNode.getAttribute('levelName') ?? 'Unknown Level';
      final programs = levelNode.findAllElements('program').map((programNode) {
        final programName = programNode.getAttribute('programName') ?? 'Unknown Program';
        final years = programNode.findAllElements('year').map((yearNode) {
          final yearNumber = int.tryParse(yearNode.getAttribute('number') ?? '0') ?? 0;
          final courses = yearNode.findAllElements('course').map((courseNode) {
            final courseCode = courseNode.getAttribute('code') ?? '';
            final courseName = courseNode.getAttribute('courseName') ?? '';
            final semType = courseNode.getAttribute('sem_type')?.toLowerCase() == 'true'; // Check sem_type
            final prerequisitesString = courseNode.getAttribute('prerequisites') ?? '';
            final prerequisites = prerequisitesString.isNotEmpty
                ? prerequisitesString.split(',')
                : <String>[];

            return Course(
              code: courseCode,
              name: courseName,
              prerequisites: prerequisites,
              type: semType ? "full" : "half", // Use semType to determine course type
            );
          }).toList();
          return Year(yearNumber: yearNumber, courses: courses);
        }).toList();
        return Program(name: programName, years: years);
      }).toList();
      return ProgramLevel(name: levelName, programs: programs);
    }).toList();
  } catch (e) {
    print("Error parsing program levels XML: $e");
    return [];
  }
}

/// Load course availability from the courseAvailability.xml file
Future<Map<String, List<String>>> loadCourseAvailability(String folder, String fileName) async {
  try {
    final String filePath = 'assets/$folder/$fileName';
    final String xmlString = await rootBundle.loadString(filePath);
    final xml.XmlDocument document = xml.XmlDocument.parse(xmlString);

    final Map<String, List<String>> availabilityMap = {};

    for (final courseNode in document.findAllElements('course')) {
      final courseCode = courseNode.findElements('course_code').first.text;
      final semester = courseNode.findElements('semester').first.text;
      final offered = courseNode.findElements('offered').first.text.toLowerCase() == 'true';

      if (offered) {
        if (!availabilityMap.containsKey(courseCode)) {
          availabilityMap[courseCode] = [];
        }
        availabilityMap[courseCode]!.add(semester);
      }
    }

    return availabilityMap;
  } catch (e) {
    print("Error parsing course availability XML: $e");
    return {};
  }
}

/// Load programs from the programs.xml file
Future<List<Program>> loadPrograms(String folder, String fileName) async {
  try {
    final String filePath = 'assets/$folder/$fileName';
    final String xmlString = await rootBundle.loadString(filePath);
    final xml.XmlDocument document = xml.XmlDocument.parse(xmlString);

    return document.findAllElements('program').map((programNode) {
      final programName = programNode.getAttribute('programName') ?? 'Unknown Program';
      final years = programNode.findAllElements('year').map((yearNode) {
        final yearNumber = int.tryParse(yearNode.getAttribute('number') ?? '0') ?? 0;
        final courses = yearNode.findAllElements('course').map((courseNode) {
          final courseCode = courseNode.getAttribute('code') ?? '';
          final courseName = courseNode.getAttribute('courseName') ?? '';
          final semType = courseNode.getAttribute('sem_type')?.toLowerCase() == 'true'; // Check sem_type
          final prerequisitesString = courseNode.getAttribute('prerequisites') ?? '';
          final prerequisites = prerequisitesString.isNotEmpty
              ? prerequisitesString.split(',')
              : <String>[];

          return Course(
            code: courseCode,
            name: courseName,
            prerequisites: prerequisites,
            type: semType ? "full" : "half", // Use semType to determine course type
          );
        }).toList();
        return Year(yearNumber: yearNumber, courses: courses);
      }).toList();
      return Program(name: programName, years: years);
    }).toList();
  } catch (e) {
    print("Error parsing programs XML: $e");
    return [];
  }
}
