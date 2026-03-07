import 'package:flutter/material.dart';

class ProviderBookingDetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProviderBookingDetailTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF161A22) : Colors.white;
    final border = isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final iconBg = isDark ? const Color(0xFF1B2230) : const Color(0xFFF3F4F6);
    final iconColor = isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151);
    final valueColor = isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: bg,
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(color: valueColor, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}