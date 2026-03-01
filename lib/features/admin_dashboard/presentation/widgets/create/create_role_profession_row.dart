import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_service_entity.dart';

class CreateRoleProfessionRow extends StatelessWidget {
  final String role;
  final ValueChanged<String> onRoleChanged;
  final TextEditingController professionController;
  final List<AdminServiceEntity> services;
  final String? selectedServiceSlug;
  final ValueChanged<String?> onServiceChanged;

  const CreateRoleProfessionRow({
    super.key,
    required this.role,
    required this.onRoleChanged,
    required this.professionController,
    required this.services,
    required this.selectedServiceSlug,
    required this.onServiceChanged,
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
            if (v.trim().toLowerCase() != 'provider') {
              onServiceChanged(null);
            }
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

        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          value: isProvider ? selectedServiceSlug : null,
          decoration: InputDecoration(
            labelText: 'Service (provider only)',
            prefixIcon: const Icon(Icons.miscellaneous_services_outlined),
            hintText: isProvider ? 'Select service' : 'Disabled for client',
          ),
          items: isProvider
              ? services
                  .map(
                    (s) => DropdownMenuItem<String>(
                      value: s.slug,
                      child: Text(s.name),
                    ),
                  )
                  .toList()
              : const [],
          onChanged: isProvider ? onServiceChanged : null,
          validator: (v) {
            if (!isProvider) return null;
            if (v == null || v.trim().isEmpty) return 'Service is required';
            return null;
          },
        ),
      ],
    );
  }
}