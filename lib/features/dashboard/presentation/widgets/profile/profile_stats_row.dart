import 'package:flutter/material.dart';

class ProfileStatsRow extends StatelessWidget {
  final String bookings;
  final String favourites;
  final String rating;

  const ProfileStatsRow({
    super.key,
    required this.bookings,
    required this.favourites,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: bookings,
            label: "Bookings",
            valueColor: const Color(0xFF3B82F6),
            bg: const Color(0xFFEFF6FF),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: favourites,
            label: "Favourites",
            valueColor: const Color(0xFF22C55E),
            bg: const Color(0xFFEAFBF2),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
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
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
