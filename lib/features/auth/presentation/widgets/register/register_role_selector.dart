import 'package:flutter/material.dart';
import 'register_form.dart';

class RegisterRoleSelector extends StatelessWidget {
  final RegisterRole role;
  final ValueChanged<RegisterRole> onChanged;

  const RegisterRoleSelector({
    super.key,
    required this.role,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Register As",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<RegisterRole>(
                value: RegisterRole.client,
                groupValue: role,
                title: const Text("Client"),
                onChanged: (v) => onChanged(v!),
              ),
            ),
            Expanded(
              child: RadioListTile<RegisterRole>(
                value: RegisterRole.provider,
                groupValue: role,
                title: const Text("Provider"),
                onChanged: (v) => onChanged(v!),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
