import 'package:firebase_database/firebase_database.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter/services.dart' show rootBundle;

Future<void> uploadProgramsFromXml() async {
  try {
    final dbRef = FirebaseDatabase.instance.ref();

    // Step 1: Load XML file from assets
    String xmlString = await rootBundle.loadString('assets/images/sbm_all_programmes.xml');
    
    // Step 2: Parse the XML
    final document = xml.XmlDocument.parse(xmlString);
    final programLevels = document.findAllElements('ProgramLevel');

    for (var level in programLevels) {
      String levelName = level.getAttribute('name') ?? 'Unknown';

      final programmes = level.findElements('Program');

      Map<String, dynamic> programMap = {};

      for (var program in programmes) {
        String programName = program.getAttribute('name') ?? 'Unnamed Program';
        programMap[programName] = true;
      }

      // Step 3: Upload to Firebase
      await dbRef.child("programmes").child(levelName).set(programMap);
    }

    print("Upload complete!");
  } catch (e) {
    print("Error uploading data: $e");
  }
}
