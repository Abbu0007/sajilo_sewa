import 'package:flutter/material.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTapTerms;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onTapTerms,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (v) => onChanged(v ?? false),
          activeColor: const Color(0xFF5B4FFF),
        ),
        const Text("Agree to "),
        GestureDetector(
          onTap: onTapTerms,
          child: const Text(
            "Terms of Service",
            style: TextStyle(color: Color(0xFF5B4FFF)),
          ),
        ),
      ],
    );
  }
}
