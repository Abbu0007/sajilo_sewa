import 'package:flutter/material.dart';

class RegisterSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RegisterSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text("Create Account"),
      ),
    );
  }
}
