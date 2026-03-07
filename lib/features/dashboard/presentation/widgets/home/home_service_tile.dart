import 'package:flutter/material.dart';

class HomeServiceTile extends StatelessWidget {
  final String name;
  final String slug;
  final int priceFrom;
  final VoidCallback onTap;

  const HomeServiceTile({
    super.key,
    required this.name,
    required this.slug,
    required this.priceFrom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF161A22) : Colors.white;
    final border =
        isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final iconBg = isDark ? const Color(0xFF1B2230) : const Color(0xFFF3F4F6);
    final subColor =
        isDark ? const Color(0xFF9CA3AF) : Colors.grey.shade600;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
          color: cardBg,
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: iconBg,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  "assets/images/$slug.png",
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(
                    "From Rs. $priceFrom",
                    style: TextStyle(color: subColor, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}