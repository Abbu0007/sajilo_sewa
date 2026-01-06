import 'package:flutter/material.dart';

class SignInLink extends StatelessWidget {
  const SignInLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? "),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text(
            "Sign In",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
