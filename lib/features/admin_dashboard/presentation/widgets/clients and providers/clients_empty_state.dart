import 'package:flutter/material.dart';

class ClientsEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const ClientsEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined,
                size: 48, color: Colors.grey.shade600),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w900, fontSize: 16)),
            const SizedBox(height: 6),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}
