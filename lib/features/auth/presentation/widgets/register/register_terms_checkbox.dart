import 'package:flutter/material.dart';

class RegisterTermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RegisterTermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: (v) => onChanged(v!)),
        const Text("Agree to Terms & Conditions"),
      ],
    );
  }
}
