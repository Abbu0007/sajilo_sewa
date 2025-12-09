import 'package:flutter/material.dart';

class RecentBookingsHeader extends StatelessWidget {
  const RecentBookingsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Text(
        'Recent Bookings',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
