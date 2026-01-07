import 'package:flutter/material.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      body: const Center(
        child: Text('News List Screen - Work in Progress'),
      ),
    );
  }
}
