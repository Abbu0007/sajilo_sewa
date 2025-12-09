import 'package:flutter/material.dart';
import 'service_card.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: const [
            ServiceCard(
              title: 'Electrician',
              icon: Icons.flash_on,
              color: Colors.blue,
            ),
            SizedBox(width: 12),
            ServiceCard(
              title: 'Plumber',
              icon: Icons.plumbing,
              color: Colors.green,
            ),
            SizedBox(width: 12),
            ServiceCard(
              title: 'Tutor',
              icon: Icons.school,
              color: Colors.yellow,
            ),
            SizedBox(width: 12),
            ServiceCard(
              title: 'Driver',
              icon: Icons.directions_car,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
