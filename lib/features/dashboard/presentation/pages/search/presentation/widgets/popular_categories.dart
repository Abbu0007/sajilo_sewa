import 'package:flutter/material.dart';

class PopularCategories extends StatelessWidget {
  const PopularCategories({super.key});

  static final _items = [
    _Item(Icons.plumbing, 'Plumbing', Color(0xFFE0F2FE)),
    _Item(Icons.bolt, 'Electrical', Color(0xFFFEF3C7)),
    _Item(Icons.cleaning_services, 'Cleaning', Color(0xFFD1FAE5)),
    _Item(Icons.format_paint, 'Painting', Color(0xFFEDE9FE)),
    _Item(Icons.carpenter, 'Carpentry', Color(0xFFFEE2E2)),
    _Item(Icons.ac_unit, 'AC Repair', Color(0xFFE0E7FF)),
    _Item(Icons.content_cut, 'Salon', Color(0xFFFCE7F3)),
    _Item(Icons.directions_car, 'Car Wash', Color(0xFFD1FAE5)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Categories',
          style: TextStyle(fontFamily: 'Quicksand Semibold', fontSize: 16),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (_, index) {
            final item = _items[index];
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item.bg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.icon),
                ),
                const SizedBox(height: 6),
                Text(item.label, style: const TextStyle(fontSize: 11)),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Item {
  final IconData icon;
  final String label;
  final Color bg;
  _Item(this.icon, this.label, this.bg);
}
