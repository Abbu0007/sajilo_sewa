import 'package:flutter/material.dart';

class HomeProviderRow extends StatelessWidget {
  final String name;
  final String profession;
  final String? avatarUrl;
  final VoidCallback onTap;

  const HomeProviderRow({
    super.key,
    required this.name,
    required this.profession,
    required this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? "U"
        : name.trim().split(RegExp(r"\s+")).take(2).map((e) => e.isNotEmpty ? e[0] : '').join().toUpperCase();

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFF3F4F6),
              child: (avatarUrl != null && avatarUrl!.isNotEmpty)
                  ? const Icon(Icons.person, color: Colors.grey) // later: NetworkImage
                  : Text(initials, style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black87)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(profession, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}