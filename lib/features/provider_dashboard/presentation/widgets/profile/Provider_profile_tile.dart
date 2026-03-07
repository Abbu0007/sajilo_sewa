import 'package:flutter/material.dart';

class ProviderProfileTile extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;
  final bool enabled;

  const ProviderProfileTile({
    super.key,
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.trailingText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF161A22) : Colors.white;
    final titleColor = enabled
        ? (isDark ? Colors.white : const Color(0xFF111827))
        : const Color(0xFF9CA3AF);
    final trailingColor = const Color(0xFF9CA3AF);
    final chevronColor =
        isDark ? const Color(0xFF6B7280) : Colors.grey.shade400;
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.18)
        : Colors.black.withOpacity(0.06);
    final borderColor =
        isDark ? const Color(0xFF2A3140) : Colors.transparent;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              spreadRadius: 0,
              color: shadowColor,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                ),
              ),
            ),
            if ((trailingText ?? '').trim().isNotEmpty)
              Text(
                trailingText!,
                style: TextStyle(
                  color: trailingColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right, color: chevronColor),
          ],
        ),
      ),
    );
  }
}