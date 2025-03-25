import 'package:flutter/material.dart';

class AddCoursePage extends StatelessWidget {
  const AddCoursePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Course'),
      ),
      body: const Center(
        child: Text('This is the Add Course page'),
      ),
    );
  }
}
