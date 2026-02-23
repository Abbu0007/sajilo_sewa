import 'package:flutter/material.dart';
import 'service_card.dart';

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: const [
        ServiceCard(
          icon: Icons.cleaning_services,
          title: 'Cleaning',
          subtitle: 'Professional cleaners',
          price: 'From Rs. 500',
        ),
        ServiceCard(
          icon: Icons.content_cut,
          title: 'Tailor',
          subtitle: 'Custom clothing',
          price: 'From Rs. 300',
        ),
        ServiceCard(
          icon: Icons.build,
          title: 'Technician',
          subtitle: 'Repair services',
          price: 'From Rs. 800',
        ),
        ServiceCard(
          icon: Icons.format_paint,
          title: 'Painter',
          subtitle: 'Interior & exterior',
          price: 'From Rs. 1200',
        ),
      ],
    );
  }
}
