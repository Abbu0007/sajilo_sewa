import 'package:flutter/material.dart';

class HomeProviderRow extends StatelessWidget {
  final String name;
  final String profession;
  final String? avatarUrl;

  final double avgRating;
  final int ratingCount;
  final int completedJobs;
  final int startingPrice;

  final VoidCallback onTap;

  const HomeProviderRow({
    super.key,
    required this.name,
    required this.profession,
    required this.avatarUrl,
    required this.avgRating,
    required this.ratingCount,
    required this.completedJobs,
    required this.startingPrice,
    required this.onTap,
  });

  String _resolveAvatarUrl(String? url) {
    if (url == null) return "";
    final u = url.trim();
    if (u.isEmpty) return "";

    return u.replaceFirst("http://localhost:5000", "http://10.0.2.2:5000");
  }

  @override
  Widget build(BuildContext context) {
    final initials = _initials(name);

    final avatar = _resolveAvatarUrl(avatarUrl);
    final hasAvatar = avatar.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
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
              backgroundImage: hasAvatar ? NetworkImage(avatar) : null,
              onBackgroundImageError: hasAvatar ? (_, __) {} : null,
              child: hasAvatar
                  ? null
                  : Text(
                      initials,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(
                    profession,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _Chip(
                        icon: Icons.star_rounded,
                        iconColor: Colors.orange,
                        label: "${avgRating.toStringAsFixed(1)} ($ratingCount)",
                      ),
                      _Chip(
                        icon: Icons.work_outline_rounded,
                        label: "$completedJobs jobs",
                      ),
                      _Chip(
                        icon: Icons.payments_outlined,
                        label: "From Rs. $startingPrice",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  static String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return "U";

    final parts =
        trimmed.split(RegExp(r"\s+")).where((e) => e.isNotEmpty).toList();

    final first = parts.isNotEmpty ? parts[0] : "U";
    final second = parts.length > 1 ? parts[1] : "";

    final i1 = first.isNotEmpty ? first[0] : "U";
    final i2 = second.isNotEmpty ? second[0] : "";

    return ("$i1$i2").toUpperCase();
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;

  const _Chip({
    required this.icon,
    required this.label,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFFF3F4F6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor ?? Colors.black54),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}