import 'package:flutter/material.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;

  final ValueChanged<bool?> onChanged;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        const Expanded(
          child: Text(
            "I agree to the Terms & Conditions",
            style: TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}
