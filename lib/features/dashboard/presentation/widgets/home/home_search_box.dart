import 'package:flutter/material.dart';

class HomeSearchBox extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const HomeSearchBox({
    super.key,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = isDark ? const Color(0xFF161A22) : const Color(0xFFF3F4F6);
    final iconColor =
        isDark ? const Color(0xFF9CA3AF) : Colors.grey.shade700;

    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(Icons.search, color: iconColor),
        filled: true,
        fillColor: fill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}