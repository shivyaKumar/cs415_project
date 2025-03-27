import 'package:flutter/material.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Menu'),
      ),
      body: const Center(
        child: Text('This is the Finance Menu page'),
      ),
    );
  }
}