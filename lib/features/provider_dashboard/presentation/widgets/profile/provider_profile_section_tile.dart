import 'package:flutter/material.dart';

class ProviderProfileSectionTitle extends StatelessWidget {
  final String title;
  const ProviderProfileSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}