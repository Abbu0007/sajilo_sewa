import 'package:flutter/material.dart';

class ProviderProfileStatsRow extends StatelessWidget {
  final String bookings;
  final String rating;
  final String earnings;

  const ProviderProfileStatsRow({
    super.key,
    required this.bookings,
    required this.rating,
    required this.earnings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: bookings,
            label: "Completed Jobs",
            valueColor: const Color(0xFF3B82F6),
            tint: const Color(0xFFEAF2FF),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: rating,
            label: "Rating",
            valueColor: const Color(0xFFF59E0B),
            tint: const Color(0xFFFFF7E6),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: earnings,
            label: "Total Earnings",
            valueColor: const Color(0xFF10B981),
            tint: const Color(0xFFECFDF5),
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
  final Color tint;

  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: valueColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}