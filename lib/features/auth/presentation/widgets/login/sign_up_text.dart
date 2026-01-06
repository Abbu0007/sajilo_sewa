import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpText extends StatelessWidget {
  final VoidCallback onSignUp;

  const SignUpText({Key? key, required this.onSignUp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
            TextSpan(
              text: 'Sign up',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF3B82F6),
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = onSignUp,
            ),
          ],
        ),
      ),
    );
  }
}
