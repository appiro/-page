import 'package:flutter/material.dart';

class TitlesScreen extends StatelessWidget {
  const TitlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Titles'),
      ),
      body: const Center(
        child: Text('Titles - Coming Soon'),
      ),
    );
  }
}
