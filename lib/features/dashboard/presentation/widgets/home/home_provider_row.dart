import 'package:flutter/material.dart';
import 'package:sajilo_sewa/core/utils/url_utils.dart';

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
    return UrlUtils.normalizeMediaUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initials = _initials(name);
    final avatar = _resolveAvatarUrl(avatarUrl);
    final hasAvatar = avatar.isNotEmpty;

    final cardBg = isDark ? const Color(0xFF161A22) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final avatarBg =
        isDark ? const Color(0xFF1B2230) : const Color(0xFFF3F4F6);
    final subColor =
        isDark ? const Color(0xFF9CA3AF) : Colors.grey.shade700;
    final chevronColor =
        isDark ? const Color(0xFF6B7280) : Colors.grey;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          color: cardBg,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: avatarBg,
              backgroundImage: hasAvatar ? NetworkImage(avatar) : null,
              onBackgroundImageError: hasAvatar ? (_, __) {} : null,
              child: hasAvatar
                  ? null
                  : Text(
                      initials,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : Colors.black87,
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
                    style: TextStyle(color: subColor, fontSize: 12),
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
            Icon(Icons.chevron_right, color: chevronColor),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1B2230) : const Color(0xFFF3F4F6);
    final border =
        isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final iconDefault =
        isDark ? const Color(0xFFD1D5DB) : Colors.black54;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: bg,
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor ?? iconDefault),
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