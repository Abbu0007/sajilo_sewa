import 'package:flutter/material.dart';

class DividerText extends StatelessWidget {
  final String text;

  const DividerText({Key? key, this.text = 'Or continue with'})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: const Color(0xFFE5E7EB))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
          ),
        ),
        Expanded(child: Container(height: 1, color: const Color(0xFFE5E7EB))),
      ],
    );
  }
}
