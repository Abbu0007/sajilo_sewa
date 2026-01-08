import 'package:flutter/material.dart';

class CreateAccountButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const CreateAccountButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        child: Text(isLoading ? "Creating..." : "Create Account"),
      ),
    );
  }
}
