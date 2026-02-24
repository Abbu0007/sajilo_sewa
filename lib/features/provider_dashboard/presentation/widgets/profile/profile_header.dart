import 'package:flutter/material.dart';

class ProviderProfileHeader extends StatelessWidget {
  final String name;
  final String? avatarUrl;

  const ProviderProfileHeader({
    super.key,
    required this.name,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    // UI later
    return Row(
      children: [
        const CircleAvatar(radius: 24, child: Icon(Icons.person)),
        const SizedBox(width: 12),
        Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))),
      ],
    );
  }
}