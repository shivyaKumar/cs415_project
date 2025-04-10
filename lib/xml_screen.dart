import 'package:flutter/material.dart';
import 'xml_loader.dart';
// SRP: The `XmlLoaderScreen` class focuses only on displaying the status of XML upload, maintaining a single responsibility.

// OCP: This class can be extended or modified to show more complex information or add other UI elements, without changing existing logic.

// LSP: The design doesn't involve inheritance, but any subclass could replace `XmlLoaderScreen` while keeping the same functionality.

// ISP: The class is not using interfaces, but it does adhere to the spirit of ISP by not forcing the screen to handle responsibilities other than UI and upload status.

// DIP: The class depends on `XmlUploader` for the logic of uploading XML, which can be abstracted or mocked for testing to improve flexibility and testability.

class XmlLoaderScreen extends StatefulWidget {
  const XmlLoaderScreen({super.key});

  @override
  State<XmlLoaderScreen> createState() => _XmlLoaderScreenState();
}

class _XmlLoaderScreenState extends State<XmlLoaderScreen> {
  String status = 'Uploading XML...';

  @override
  void initState() {
    super.initState();
    upload();
  }

 Future<void> upload() async {
  final result = await XmlUploader.uploadAllXmlData();
  setState(() {
    status = result;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload XML to Firebase')),
      body: Center(child: Text(status)),
    );
  }
}
