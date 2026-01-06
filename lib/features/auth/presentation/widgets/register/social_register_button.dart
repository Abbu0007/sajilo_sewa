import 'package:flutter/material.dart';

class SocialRegisterButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const SocialRegisterButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    Icon icon;

    if (label == "Google") {
      icon = const Icon(Icons.g_mobiledata, color: Colors.red, size: 28);
    } else if (label == "Apple") {
      icon = const Icon(Icons.apple, size: 26);
    } else {
      icon = const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 26);
    }

    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              "Continue with $label",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
