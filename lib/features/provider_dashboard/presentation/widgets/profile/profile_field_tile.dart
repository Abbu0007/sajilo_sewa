import 'package:flutter/material.dart';

class ProfileFieldTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const ProfileFieldTile({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(value),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}