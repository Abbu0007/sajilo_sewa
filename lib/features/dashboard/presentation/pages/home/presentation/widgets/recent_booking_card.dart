import 'package:flutter/material.dart';
import 'package:sajilo_sewa/core/utils/styles.dart';

class RecentBookingCard extends StatelessWidget {
  final String name;
  final String service;
  final String price;

  const RecentBookingCard({
    super.key,
    required this.name,
    required this.service,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(),
        title: Text(name, style: AppStyles.subheading),
        subtitle: Text(service, style: AppStyles.caption),
        trailing: Text(
          price,
          style: const TextStyle(fontFamily: 'Quicksand Medium'),
        ),
      ),
    );
  }
}
