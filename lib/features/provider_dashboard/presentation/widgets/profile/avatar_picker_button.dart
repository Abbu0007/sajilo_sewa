import 'package:flutter/material.dart';

class AvatarPickerButton extends StatelessWidget {
  final VoidCallback onPick;

  const AvatarPickerButton({super.key, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPick,
      icon: const Icon(Icons.camera_alt_outlined),
      label: const Text("Change Avatar"),
    );
  }
}