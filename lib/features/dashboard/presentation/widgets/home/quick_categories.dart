import 'package:flutter/material.dart';

class QuickCategories extends StatelessWidget {
  const QuickCategories({super.key});

  static final List<_Item> items = [
    _Item(Icons.flash_on, 'Electrician', Color(0xFFE0EDFF)),
    _Item(Icons.build, 'Plumber', Color(0xFFE7F8ED)),
    _Item(Icons.school, 'Tutor', Color(0xFFFFF4CC)),
    _Item(Icons.directions_car, 'Driver', Color(0xFFF3E8FF)),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((e) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: e.bg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(e.icon),
            ),
            const SizedBox(height: 6),
            Text(e.label, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }
}

class _Item {
  final IconData icon;
  final String label;
  final Color bg;
  _Item(this.icon, this.label, this.bg);
}
