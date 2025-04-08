import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;

class XmlUploadScreen extends StatefulWidget {
  const XmlUploadScreen({super.key});

  @override
  State<XmlUploadScreen> createState() => _XmlUploadScreenState();
}

class _XmlUploadScreenState extends State<XmlUploadScreen> {
  String statusMessage = "Press the button to upload XML data.";

  Future<void> uploadProgramsFromXml() async {
    setState(() => statusMessage = "📦 Uploading...");

    try {
      final dbRef = FirebaseDatabase.instance.ref();

      // Load XML file
      String xmlString = await rootBundle.loadString('assets/images/sbm_all_programmes.xml');

      // Parse XML
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

        await dbRef.child("programmes").child(levelName).set(programMap);
      }

      setState(() => statusMessage = "✅ XML data uploaded successfully!");
    } catch (e) {
      setState(() => statusMessage = "❌ Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload XML to Firebase")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(statusMessage, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadProgramsFromXml,
              child: const Text("Upload XML"),
            ),
          ],
        ),
      ),
    );
  }
}
