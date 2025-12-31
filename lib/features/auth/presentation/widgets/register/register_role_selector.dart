import 'package:flutter/material.dart';

class RegisterRoleSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const RegisterRoleSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Register As",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                title: const Text("Client"),
                value: 'client',
                groupValue: value,
                onChanged: (v) => onChanged(v!),
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: const Text("Service Provider"),
                value: 'provider',
                groupValue: value,
                onChanged: (v) => onChanged(v!),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
