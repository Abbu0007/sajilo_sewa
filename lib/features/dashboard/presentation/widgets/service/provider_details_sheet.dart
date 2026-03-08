import 'package:flutter/material.dart';
import 'package:sajilo_sewa/core/utils/url_utils.dart';
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
    final initials = _initials(name);

    final phone = provider.phone.trim();
    final email = provider.email.trim();
    final avatar = UrlUtils.normalizeMediaUrl(provider.avatarUrl);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final handleColor =
        isDark ? const Color(0xFF4B5563) : Colors.grey.shade300;
    final avatarBg =
        isDark ? const Color(0xFF1B2230) : const Color(0xFFF3F4F6);
    final professionColor =
        isDark ? const Color(0xFF9CA3AF) : Colors.grey.shade700;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 44,
                decoration: BoxDecoration(
                  color: handleColor,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Provider Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onToggleFavourite,
                    icon: Icon(
                      isFavourite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFavourite
                          ? Colors.red
                          : (isDark ? Colors.white70 : Colors.black54),
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
                backgroundColor: avatarBg,
                backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
                child: avatar.isNotEmpty
                    ? null
                    : Text(
                        initials,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              Text(
                provider.fullName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                provider.profession,
                style: TextStyle(
                  color: professionColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _StatChip(
                    icon: Icons.star_rounded,
                    iconColor: Colors.orange,
                    text:
                        "${provider.avgRating.toStringAsFixed(1)} (${provider.ratingCount})",
                  ),
                  _StatChip(
                    icon: Icons.work_outline_rounded,
                    text: "${provider.completedJobs} jobs",
                  ),
                  _StatChip(
                    icon: Icons.payments_outlined,
                    text: "From Rs. ${provider.startingPrice}",
                  ),
                ],
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
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: const Text("Close"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onBook,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                      child: const Text("Book Now"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _initials(String name) {
    final t = name.trim();
    if (t.isEmpty) return "U";
    final parts = t.split(RegExp(r"\s+")).where((e) => e.isNotEmpty).toList();
    final a = parts.isNotEmpty ? parts[0][0] : "U";
    final b = parts.length > 1 ? parts[1][0] : "";
    return ("$a$b").toUpperCase();
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;

  const _StatChip({
    required this.icon,
    required this.text,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1B2230) : const Color(0xFFF3F4F6);
    final border =
        isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final defaultIcon =
        isDark ? const Color(0xFFD1D5DB) : Colors.black54;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: bg,
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor ?? defaultIcon),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF161A22) : Colors.white;
    final border =
        isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final iconColor =
        isDark ? const Color(0xFFD1D5DB) : Colors.grey.shade700;
    final labelColor =
        isDark ? const Color(0xFF9CA3AF) : Colors.grey.shade600;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        color: bg,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: labelColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}