import 'package:flutter/material.dart';

class RecentSearches extends StatelessWidget {
  const RecentSearches({super.key});

  static final _searches = [
    'Home Cleaning Service',
    'Plumber near me',
    'AC Repair Service',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Recent Searches',
                style: TextStyle(
                  fontFamily: 'Quicksand Semibold',
                  fontSize: 16,
                ),
              ),
              Spacer(),
              Text(
                'Clear All',
                style: TextStyle(color: Colors.blue, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._searches.map(
            (e) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history),
              title: Text(e),
              trailing: const Icon(Icons.close, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
