import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses and Prerequisities'),
      ),
      body: const Center(
        child: Text('This is the page for courses and prerequisities'),
      ),
    );
  }
}