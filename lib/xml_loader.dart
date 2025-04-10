import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_database/firebase_database.dart';
import 'package:xml/xml.dart';
import 'dart:math';
  // SRP: XmlUploader class is responsible only for parsing and uploading XML data, maintaining a single responsibility.
  // OCP: The class can be extended to handle additional XML parsing or upload tasks without modifying existing methods.
  // LSP: The class design doesn’t involve inheritance, but if extended, derived classes would behave in a predictable manner (substituting base methods).
  // ISP: No interfaces are used, but the class handles different XML types in separate methods, keeping the responsibilities clear and modular.
  // DIP: The class directly depends on FirebaseDatabase and file loading logic, but using interfaces for Firebase and file handling could improve testability and flexibility.
class XmlUploader {
  static Future<String> uploadAllXmlData() async {
    try {
      final database = FirebaseDatabase.instance;

      /// 1. Upload subprogrammes
      final subProgramData = await _parseSubProgrammes();
      final subProgrammeRef = database.ref("subprogrammes");
      await subProgrammeRef.set(subProgramData);

      /// 2. Upload programmes and link to subprogramme_id
      final programData = await _parsePrograms(subProgramData);
      final programRef = database.ref("programs");
      await programRef.set(programData);

      /// 3. Upload prerequisites
      final prerequisiteData = await _parsePrerequisites();
      final prereqRef = database.ref("prerequisites");
      await prereqRef.set(prerequisiteData);

      /// 4. Upload semtypes and map by course_id
      final semTypeData = await _parseSemTypes();
      final semTypeRef = database.ref("semtype");
      await semTypeRef.set(semTypeData);

      /// 5. Upload course availability and link course_id + semtype_id
      final courseAvailabilityData = await _parseCourseAvailability(semTypeData);
      final courseAvailabilityRef = database.ref("course_availability");
      await courseAvailabilityRef.set(courseAvailabilityData);

      /// 6. Upload courses and link course_availability_id + prerequisites_id
      final courseData = await _parseCourses(courseAvailabilityData, prerequisiteData);
      final coursesRef = database.ref("courses");
      await coursesRef.set(courseData);

      return '✅ All XML data uploaded successfully!';
    } catch (e) {
      return '❌ Error uploading XML: $e';
    }
  }

  static Future<Map<String, dynamic>> _parseSubProgrammes() async {
    final xmlString = await rootBundle.loadString('assets/images/subprogrammes.xml');
    final document = XmlDocument.parse(xmlString);
    final data = <String, dynamic>{};
    int index = 1;

    for (var sub in document.findAllElements('subProgram')) {
      final name = sub.getAttribute('subProgramName') ?? 'Unknown';
      final id = 'SUBPROG${index.toString().padLeft(3, '0')}';
      data[id] = {'name': name, 'id': id};
      index++;
    }
    return data;
  }

  static Future<Map<String, dynamic>> _parsePrograms(Map<String, dynamic> subProgrammes) async {
    final xmlString = await rootBundle.loadString('assets/images/programs.xml');
    final document = XmlDocument.parse(xmlString);
    final data = <String, dynamic>{};
    int index = 1;
    final subProgKeys = subProgrammes.keys.toList();

    for (var program in document.findAllElements('program')) {
      final name = program.getAttribute('programName') ?? 'Unknown';
      final id = 'PROG${index.toString().padLeft(3, '0')}';
      final subProgId = subProgKeys[Random().nextInt(subProgKeys.length)];
      data[id] = {'name': name, 'id': id, 'subprogramme_id': subProgId};
      index++;
    }
    return data;
  }

  static Future<Map<String, dynamic>> _parsePrerequisites() async {
    final xmlString = await rootBundle.loadString('assets/images/prerequisities.xml');
    final document = XmlDocument.parse(xmlString);
    final data = <String, dynamic>{};
    int index = 1;

    for (var unit in document.findAllElements('unit')) {
      final code = unit.getElement('code')?.text ?? 'UNKNOWN';
      final id = 'PREREQ${index.toString().padLeft(3, '0')}';
      data[id] = {'id': id, 'course_id': code};
      index++;
    }
    return data;
  }

  static Future<Map<String, dynamic>> _parseSemTypes() async {
    final xmlString = await rootBundle.loadString('assets/images/semType.xml');
    final document = XmlDocument.parse(xmlString);
    final data = <String, dynamic>{};
    int index = 1;

    for (var unit in document.findAllElements('Unit')) {
      final code = unit.getAttribute('code') ?? 'UNKNOWN';
      final id = 'SEMTYPE${index.toString().padLeft(3, '0')}';
      data[id] = {'id': id, 'course_id': code};
      index++;
    }
    return data;
  }

  static Future<Map<String, dynamic>> _parseCourseAvailability(Map<String, dynamic> semTypeData) async {
    final xmlString = await rootBundle.loadString('assets/images/courseAvailability.xml');
    final document = XmlDocument.parse(xmlString);
    final data = <String, dynamic>{};
    int index = 1;

    for (var course in document.findAllElements('course')) {
      final courseCode = course.getElement('course_code')?.text ?? 'UNKNOWN';
      final semester = course.getElement('semester')?.text ?? 'UNKNOWN';
      final offered = course.getElement('offered')?.text ?? 'false';
      final id = 'AVAIL${index.toString().padLeft(3, '0')}';

      // Try to find a matching semtype_id
      final semtypeId = semTypeData.entries
          .firstWhere((e) => e.value['course_id'] == courseCode, orElse: () => MapEntry('UNKNOWN', {}))
          .key;

      data[id] = {
        'id': id,
        'course_id': courseCode,
        'semtype_id': semtypeId,
        'semester': semester,
        'offered': offered == 'true'
      };
      index++;
    }
    return data;
  }

  static Future<Map<String, dynamic>> _parseCourses(
      Map<String, dynamic> courseAvailData, Map<String, dynamic> prereqData) async {
    final xmlString = await rootBundle.loadString('assets/images/courses.xml');
    final document = XmlDocument.parse(xmlString);
    final data = <String, dynamic>{};
    int index = 1;

    for (var unit in document.findAllElements('Unit')) {
      final code = unit.getAttribute('code') ?? 'UNKNOWN';
      final name = unit.getAttribute('courseName') ?? 'Unnamed';
      final id = 'COURSE${index.toString().padLeft(3, '0')}';

      final courseAvailId = courseAvailData.entries
          .firstWhere((e) => e.value['course_id'] == code, orElse: () => MapEntry('UNKNOWN', {}))
          .key;

      final prereqId = prereqData.entries
          .firstWhere((e) => e.value['course_id'] == code, orElse: () => MapEntry('UNKNOWN', {}))
          .key;

      data[id] = {
        'id': id,
        'code': code,
        'name': name,
        'course_availability_id': courseAvailId,
        'course_prerequisites_id': prereqId
      };
      index++;
    }

    return data;
  }
}
