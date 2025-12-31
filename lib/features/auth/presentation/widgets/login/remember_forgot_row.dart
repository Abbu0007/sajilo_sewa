import 'package:flutter/material.dart';

class RememberForgotRow extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onForgot;

  const RememberForgotRow({
    Key? key,
    required this.rememberMe,
    required this.onChanged,
    required this.onForgot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: rememberMe,
                onChanged: onChanged,
                activeColor: const Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Remember me',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ],
        ),
        GestureDetector(
          onTap: onForgot,
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF3B82F6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
