import 'package:flutter/material.dart';
import 'package:sajilo_sewa/core/widgets/my_textformfield.dart';

class ProfessionField extends StatelessWidget {
  final TextEditingController controller;

  /// ✅ used in RegisterForm as: onTapPick: () { ... }
  final VoidCallback? onTapPick;

  const ProfessionField({
    super.key,
    required this.controller,
    this.onTapPick,
  });

  @override
  Widget build(BuildContext context) {
    return MyTextFormField(
      label: "Profession",
      controller: controller,
      hint: "e.g. Plumber, Electrician",
      icon: Icons.work_outline,
      // keep manual entry allowed
      validator: (v) {
        if (v == null || v.trim().isEmpty) return "Profession is required";
        return null;
      },
      suffix: onTapPick == null
          ? null
          : IconButton(
              icon: const Icon(Icons.keyboard_arrow_down),
              onPressed: onTapPick,
            ),
    );
  }
}
