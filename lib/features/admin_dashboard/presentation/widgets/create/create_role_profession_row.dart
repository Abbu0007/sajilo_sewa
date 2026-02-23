import 'package:flutter/material.dart';

class CreateRoleProfessionRow extends StatelessWidget {
  final String role;
  final ValueChanged<String> onRoleChanged;
  final TextEditingController professionController;

  const CreateRoleProfessionRow({
    super.key,
    required this.role,
    required this.onRoleChanged,
    required this.professionController,
  });

  @override
  Widget build(BuildContext context) {
    final r = role.trim().toLowerCase();
    final isProvider = r == 'provider';

    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: r.isEmpty ? 'client' : r,
          decoration: const InputDecoration(
            labelText: 'Role',
            prefixIcon: Icon(Icons.badge_outlined),
          ),
          items: const [
            DropdownMenuItem(value: 'client', child: Text('Client')),
            DropdownMenuItem(value: 'provider', child: Text('Service Provider')),
          ],
          onChanged: (v) {
            if (v == null) return;
            onRoleChanged(v);
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: professionController,
          enabled: isProvider,
          decoration: InputDecoration(
            labelText: 'Profession (provider only)',
            prefixIcon: const Icon(Icons.work_outline),
            hintText: isProvider ? 'e.g. Electrician' : 'Disabled for client',
          ),
          validator: (v) {
            if (!isProvider) return null;
            if (v == null || v.trim().isEmpty) return 'Profession is required';
            return null;
          },
        ),
      ],
    );
  }
}
