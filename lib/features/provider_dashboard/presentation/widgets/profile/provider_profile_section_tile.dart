import 'package:flutter/material.dart';

class ProviderProfileSectionTitle extends StatelessWidget {
  final String title;
  const ProviderProfileSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}