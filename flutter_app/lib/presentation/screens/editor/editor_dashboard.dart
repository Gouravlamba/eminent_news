import 'package:flutter/material.dart';

class EditorDashboard extends StatelessWidget {
  const EditorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor - My News'),
      ),
      body: const Center(
        child: Text('Editor Dashboard - Work in Progress'),
      ),
    );
  }
}
