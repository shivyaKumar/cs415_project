import 'package:flutter/material.dart';

class CourseSelectionPage extends StatelessWidget {
  const CourseSelectionPage({super.key});

  void navigateTo(BuildContext context, String programName) {
    switch (programName) {
      case 'SAGEONS':
        Navigator.pushNamed(context, '/sageons');
        break;
      // Add other pages when available
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$programName page is under development!')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> programs = ['SPACE', 'STEMP', 'SOLASS', 'SAGEONS', 'SAFE', 'SBM'];

    return Scaffold(
      appBar: AppBar(title: Text("Select Program")),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2,
        ),
        itemCount: programs.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => navigateTo(context, programs[index]),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  programs[index],
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
