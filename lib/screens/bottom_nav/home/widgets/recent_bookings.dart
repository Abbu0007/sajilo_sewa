import 'package:flutter/material.dart';
import 'recent_booking_card.dart';

class RecentBookings extends StatelessWidget {
  const RecentBookings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        RecentBookingCard(
          name: 'Bhusan Shrestha',
          service: 'Electrician • Completed',
          price: 'Rs. 1500',
        ),
        SizedBox(height: 10),
        RecentBookingCard(
          name: 'Sita Tamang',
          service: 'House Cleaning • In Progress',
          price: 'Rs. 800',
        ),
      ],
    );
  }
}
