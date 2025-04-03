import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;

import '../models/course_model.dart';
import '../models/program_level_model.dart';
import '../models/program_model.dart';
import '../models/year_model.dart';

/// Load courses from the courses.xml file
Future<List<Course>> loadCourses(String filePath) async {
  try {
    final String xmlString = await rootBundle.loadString(filePath);
    final xml.XmlDocument document = xml.XmlDocument.parse(xmlString);

    return document.findAllElements('course').map((courseNode) {
      final courseCode = courseNode.getAttribute('code') ?? '';
      final courseName = courseNode.getAttribute('courseName') ?? '';
      final type = courseNode.getAttribute('courseTypeName') ?? '';
      final prerequisitesString = courseNode.getAttribute('prerequisites') ?? '';
      final prerequisites = prerequisitesString.isNotEmpty
          ? prerequisitesString.split(',')
          : <String>[];

      return Course(
        code: courseCode,
        name: courseName,
        prerequisites: prerequisites,
        type: type,
      );
    }).toList();
  } catch (e) {
    print("Error parsing courses XML: $e");
    return [];
  }
}

/// Load prerequisites from the prerequisites.xml file
Future<Map<String, List<String>>> loadPrerequisites(String filePath) async {
  try {
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
Future<List<ProgramLevel>> loadProgramLevels(String filePath) async {
  try {
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
            final type = courseNode.getAttribute('courseTypeName') ?? '';
            final prerequisitesString = courseNode.getAttribute('prerequisites') ?? '';
            final prerequisites = prerequisitesString.isNotEmpty
                ? prerequisitesString.split(',')
                : <String>[];

            return Course(
              code: courseCode,
              name: courseName,
              prerequisites: prerequisites,
              type: type,
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

/// Load programs from the programs.xml file
Future<List<Program>> loadPrograms(String filePath) async {
  try {
    final String xmlString = await rootBundle.loadString(filePath);
    final xml.XmlDocument document = xml.XmlDocument.parse(xmlString);

    return document.findAllElements('program').map((programNode) {
      final programName = programNode.getAttribute('programName') ?? 'Unknown Program';
      final years = programNode.findAllElements('year').map((yearNode) {
        final yearNumber = int.tryParse(yearNode.getAttribute('number') ?? '0') ?? 0;
        final courses = yearNode.findAllElements('course').map((courseNode) {
          final courseCode = courseNode.getAttribute('code') ?? '';
          final courseName = courseNode.getAttribute('courseName') ?? '';
          final type = courseNode.getAttribute('courseTypeName') ?? '';
          final prerequisitesString = courseNode.getAttribute('prerequisites') ?? '';
          final prerequisites = prerequisitesString.isNotEmpty
              ? prerequisitesString.split(',')
              : <String>[];

          return Course(
            code: courseCode,
            name: courseName,
            prerequisites: prerequisites,
            type: type,
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

/// Load program types from the programTypes.xml file
Future<List<String>> loadProgramTypes(String filePath) async {
  try {
    final String xmlString = await rootBundle.loadString(filePath);
    final xml.XmlDocument document = xml.XmlDocument.parse(xmlString);

    return document.findAllElements('programType').map((element) {
      return element.getAttribute('programTypeName') ?? 'Unknown Program Type';
    }).toList();
  } catch (e) {
    print("Error parsing program types XML: $e");
    return [];
  }
}

/// Load semesters from the semesters.xml file
Future<List<String>> loadSemesters(String filePath) async {
  try {
    final String xmlString = await rootBundle.loadString(filePath);
    final xml.XmlDocument document = xml.XmlDocument.parse(xmlString);

    return document.findAllElements('semester').map((element) {
      return element.getAttribute('semesterName') ?? 'Unknown Semester';
    }).toList();
  } catch (e) {
    print("Error parsing semesters XML: $e");
    return [];
  }
}

/// Load sub-programs from the subPrograms.xml file
Future<List<String>> loadSubPrograms(String filePath) async {
  try {
    final String xmlString = await rootBundle.loadString(filePath);
    final xml.XmlDocument document = xml.XmlDocument.parse(xmlString);

    return document.findAllElements('subProgram').map((element) {
      return element.getAttribute('subProgramName') ?? 'Unknown Sub-Program';
    }).toList();
  } catch (e) {
    print("Error parsing sub-programs XML: $e");
    return [];
  }
}