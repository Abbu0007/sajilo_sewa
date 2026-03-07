import 'package:flutter/material.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onAction;

  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final actionColor =
        isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);

    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: onAction,
          child: Text(
            actionText,
            style: TextStyle(
              color: actionColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}