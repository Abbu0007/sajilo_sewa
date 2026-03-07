import 'package:flutter/material.dart';

class ProviderQuickActions extends StatelessWidget {
  final int pending;
  final int confirmed;
  final int inProgress;
  final int completed;

  const ProviderQuickActions({
    super.key,
    required this.pending,
    required this.confirmed,
    required this.inProgress,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _StatCard(title: "Pending", value: pending)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(title: "Confirmed", value: confirmed)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _StatCard(title: "In Progress", value: inProgress)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(title: "Completed", value: completed)),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor =
        isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151);
    final valueColor =
        isDark ? Colors.white : const Color(0xFF111827);
    final bgColor =
        isDark ? const Color(0xFF161A22) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}