import 'package:flutter/material.dart';

class ProfileStatsRow extends StatelessWidget {
  final String completedBookings;
  final String rating;
  final String totalReviews;

  const ProfileStatsRow({
    super.key,
    required this.completedBookings,
    required this.rating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: completedBookings,
            label: "Completed Bookings",
            valueColor: const Color(0xFF3B82F6),
            bg: const Color(0xFFEFF6FF),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: rating,
            label: "Rating",
            valueColor: const Color(0xFFF59E0B),
            bg: const Color(0xFFFFF7ED),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: totalReviews,
            label: "Total Reviews",
            valueColor: const Color(0xFF6366F1),
            bg: const Color(0xFFEEF2FF),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final Color bg;

  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF161A22) : bg;
    final labelColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final borderColor =
        isDark ? const Color(0xFF2A3140) : Colors.transparent;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}