import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_database/firebase_database.dart';
import 'package:xml/xml.dart';
import 'dart:math';

class XmlUploader {
  static Future<String> uploadAllXmlData() async {
    try {
      final database = FirebaseDatabase.instance;

      /// 1. Upload subprogrammes
      final subProgrammeRef = database.ref("subprogrammes");
      final subProgramSnapshot = await subProgrammeRef.get();
      if (!subProgramSnapshot.exists) {
        final subProgramData = await parseSubProgrammes();
        await subProgrammeRef.set(subProgramData);
      }

      /// 2. Upload programmes and link to subprogramme_id
      final programRef = database.ref("programs");
      final programSnapshot = await programRef.get();
      if (!programSnapshot.exists) {
        final subProgramData = await parseSubProgrammes();
        final programData = await parsePrograms(subProgramData);
        await programRef.set(programData);
      }

      /// 3. Upload prerequisites
      final prereqRef = database.ref("prerequisites");
      final prereqSnapshot = await prereqRef.get();
      if (!prereqSnapshot.exists) {
        final prerequisiteData = await parsePrerequisites();
        await prereqRef.set(prerequisiteData);
      }

      /// 4. Upload semtypes and map by course_id
      final semTypeRef = database.ref("semtype");
      final semTypeSnapshot = await semTypeRef.get();
      if (!semTypeSnapshot.exists) {
        final semTypeData = await parseSemTypes();
        await semTypeRef.set(semTypeData);
      }

      /// 5. Upload course availability and link course_id + semtype_id
      final courseAvailabilityRef = database.ref("course_availability");
      final courseAvailabilitySnapshot = await courseAvailabilityRef.get();
      if (!courseAvailabilitySnapshot.exists) {
        final semTypeData = await parseSemTypes();
        final courseAvailabilityData = await parseCourseAvailability(semTypeData);
        await courseAvailabilityRef.set(courseAvailabilityData);
      }

      /// 6. Upload courses and link course_availability_id + prerequisites_id
      final coursesRef = database.ref("courses");
      final coursesSnapshot = await coursesRef.get();
      if (!coursesSnapshot.exists) {
        final semTypeData = await parseSemTypes();
        final courseAvailabilityData = await parseCourseAvailability(semTypeData);
        final prerequisiteData = await parsePrerequisites();
        final courseData = await parseCourses(courseAvailabilityData, prerequisiteData);
        await coursesRef.set(courseData);
      }

      return '✅ All XML data uploaded successfully!';
    } catch (e) {
      return '❌ Error uploading XML: $e';
    }
  }

  static Future<Map<String, dynamic>> parseSubProgrammes() async {
    final xmlString = await rootBundle.loadString('assets/XMLs/subprogrammes.xml');
    final document = XmlDocument.parse(xmlString);
    final data = <String, dynamic>{};
    int index = 1;

    // Find all <subprogram> elements
    for (var sub in document.findAllElements('subprogram')) {
      final name = sub.getAttribute('subprogramName'); // Match the attribute name in the XML file
      if (name != null && name.isNotEmpty) {
        final id = 'SUBPROG${index.toString().padLeft(3, '0')}';
        data[id] = {'name': name, 'id': id};
        index++;
      }
    }

    // Check if no subprograms were parsed
    if (data.isEmpty) {
      throw Exception("No subprograms found in the XML file. Please check the XML structure.");
    }

    return data;
  }

  static Future<Map<String, dynamic>> parsePrograms(Map<String, dynamic> subProgrammes) async {
    final xmlString = await rootBundle.loadString('assets/XMLs/programs.xml');
    final document = XmlDocument.parse(xmlString);
    final data = <String, dynamic>{};
    int index = 1;

    // Check if subProgrammes is empty
    if (subProgrammes.isEmpty) {
      throw Exception("No subprogrammes found. Please ensure subprogrammes are loaded correctly.");
    }

    final subProgKeys = subProgrammes.keys.toList();

    for (var program in document.findAllElements('program')) {
      final name = program.getAttribute('programName') ?? 'Unknown';
      final id = 'PROG${index.toString().padLeft(3, '0')}';

      // Randomly assign a subprogramme ID
      final subProgId = subProgKeys[Random().nextInt(subProgKeys.length)];
      data[id] = {'name': name, 'id': id, 'subprogramme_id': subProgId};
      index++;
    }
    return data;
  }

  static Future<Map<String, dynamic>> parsePrerequisites() async {
    final xmlString = await rootBundle.loadString('assets/XMLs/prerequisities.xml');
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

  static Future<Map<String, dynamic>> parseSemTypes() async {
    final xmlString = await rootBundle.loadString('assets/XMLs/semType.xml');
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

  static Future<Map<String, dynamic>> parseCourseAvailability(Map<String, dynamic> semTypeData) async {
    final xmlString = await rootBundle.loadString('assets/XMLs/courseAvailability.xml');
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

  static Future<Map<String, dynamic>> parseCourses(
      Map<String, dynamic> courseAvailData, Map<String, dynamic> prereqData) async {
    final xmlString = await rootBundle.loadString('assets/XMLs/courses.xml');
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

  /// Fetch campuses from Firebase
  static Future<List<String>> fetchCampuses() async {
    try {
      final database = FirebaseDatabase.instance;
      final snapshot = await database.ref("campus").get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        // Extract campus names from the database structure
        return data.values.map((campus) => campus as String).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching campuses: $e");
      return [];
    }
  }
}