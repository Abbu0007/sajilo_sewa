import 'package:flutter/material.dart';
import 'service_item.dart';

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: const [
          ServiceItem(
            title: 'Cleaning',
            subtitle: 'Professional cleaners',
            price: 'Rs. 500',
            icon: Icons.cleaning_services,
            color: Colors.orange,
          ),
          ServiceItem(
            title: 'Tailor',
            subtitle: 'Custom clothing',
            price: 'Rs. 300',
            icon: Icons.design_services,
            color: Colors.pink,
          ),
          ServiceItem(
            title: 'Technician',
            subtitle: 'Repair & maintain',
            price: 'Rs. 800',
            icon: Icons.build,
            color: Colors.red,
          ),
          ServiceItem(
            title: 'Painter',
            subtitle: 'Interior & exterior',
            price: 'Rs. 1200',
            icon: Icons.format_paint,
            color: Colors.teal,
          ),
        ],
      ),
    );
  }
}
