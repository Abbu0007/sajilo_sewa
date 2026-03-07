import 'package:flutter/material.dart';

class ProfileInfoSheet extends StatelessWidget {
  final String title;
  final Widget content;

  const ProfileInfoSheet({
    super.key,
    required this.title,
    required this.content,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required Widget content,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.8,
        child: ProfileInfoSheet(title: title, content: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final handleColor =
        isDark ? const Color(0xFF4B5563) : Colors.grey.shade300;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          children: [
            Container(
              height: 5,
              width: 44,
              decoration: BoxDecoration(
                color: handleColor,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                )
              ],
            ),

            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}