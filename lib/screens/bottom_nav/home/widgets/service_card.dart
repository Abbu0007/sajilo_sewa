import 'package:flutter/material.dart';
import '../../../../common/styles.dart';

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String price;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(height: 12),
            Text(title, style: AppStyles.subheading),
            const SizedBox(height: 4),
            Text(subtitle, style: AppStyles.caption),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(
                color: Colors.blue,
                fontFamily: 'Quicksand Medium',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
