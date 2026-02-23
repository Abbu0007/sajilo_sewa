import 'package:flutter/material.dart';

class TrendingServices extends StatelessWidget {
  const TrendingServices({super.key});

  static final _items = [
    'Deep Cleaning',
    'Kitchen Repair',
    'Wall Painting',
    'Bathroom Cleaning',
    'Furniture Assembly',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trending Services',
            style: TextStyle(fontFamily: 'Quicksand Semibold', fontSize: 16),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _items
                .map(
                  (e) => Chip(
                    label: Text(e),
                    backgroundColor: const Color(0xFFF3F4F6),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
