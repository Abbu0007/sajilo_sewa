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
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              spreadRadius: 0,
              color: Colors.black.withOpacity(0.06),
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
                  color: enabled ? const Color(0xFF111827) : const Color(0xFF9CA3AF),
                ),
              ),
            ),
            if ((trailingText ?? '').trim().isNotEmpty)
              Text(
                trailingText!,
                style: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}