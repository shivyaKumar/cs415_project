import 'package:flutter/material.dart';
import 'xml_loader.dart';

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
