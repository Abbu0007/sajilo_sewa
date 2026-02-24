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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF374151)),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}