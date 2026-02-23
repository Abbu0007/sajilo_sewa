import 'package:flutter/material.dart';
import '../../../domain/entities/provider_entity.dart';

class ProviderDetailsSheet extends StatelessWidget {
  final ProviderEntity provider;
  final bool isFavourite;
  final VoidCallback onToggleFavourite;
  final VoidCallback onBook;

  const ProviderDetailsSheet({
    super.key,
    required this.provider,
    required this.isFavourite,
    required this.onToggleFavourite,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final name = provider.fullName.trim();
    final initials = name.isEmpty
        ? "U"
        : name
            .split(RegExp(r"\s+"))
            .take(2)
            .map((e) => e.isNotEmpty ? e[0] : "")
            .join()
            .toUpperCase();

    final phone = (provider.phone ?? "").trim();
    final email = (provider.email ?? "").trim();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 44,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Provider Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 6),

            CircleAvatar(
              radius: 34,
              backgroundColor: const Color(0xFFF3F4F6),
              child: (provider.avatarUrl != null && provider.avatarUrl!.isNotEmpty)
                  ? const Icon(Icons.person, size: 34, color: Colors.grey)
                  : Text(initials, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            ),
            const SizedBox(height: 10),

            Text(
              provider.fullName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              provider.profession ?? "Professional",
              style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 16),

            _InfoTile(
              icon: Icons.phone,
              label: "Phone",
              value: phone.isEmpty ? "Not provided" : phone,
            ),
            const SizedBox(height: 10),
            _InfoTile(
              icon: Icons.mail_outline,
              label: "Email",
              value: email.isEmpty ? "Not provided" : email,
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                const Spacer(),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text("Close"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: onBook,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                  child: const Text("Book Now"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}