import 'package:flutter/material.dart';

class OnboardPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath; // Add this

  const OnboardPage({
    Key? key,
    required this.title,
    required this.subtitle,
    this.imagePath = '', // optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imagePath.isNotEmpty) Image.asset(imagePath, height: 250),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
