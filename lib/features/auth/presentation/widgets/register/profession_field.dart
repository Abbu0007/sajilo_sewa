import 'package:flutter/material.dart';

class ProfessionField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onOpenPicker;

  const ProfessionField({
    super.key,
    required this.controller,
    required this.onOpenPicker,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Profession",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onTap: onOpenPicker,
          decoration: InputDecoration(
            hintText: "Carpenter / Plumber ...",
            prefixIcon: const Icon(Icons.work_outline),
            suffixIcon: IconButton(
              icon: const Icon(Icons.arrow_drop_down),
              onPressed: onOpenPicker,
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
