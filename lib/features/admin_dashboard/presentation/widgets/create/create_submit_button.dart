import 'package:flutter/material.dart';

class CreateSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const CreateSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 10),
              ],
              Text(isLoading ? 'Creating...' : 'Create User'),
            ],
          ),
        ),
      ),
    );
  }
}
