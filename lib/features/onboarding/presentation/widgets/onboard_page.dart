import 'package:flutter/material.dart';

class OnboardPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const OnboardPage({
    super.key,
    required this.title,
    required this.subtitle,
    this.imagePath = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imagePath.isNotEmpty)
            Image.asset(
              imagePath,
              height: 280,
              fit: BoxFit.contain,
            ),

          const SizedBox(height: 50),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}