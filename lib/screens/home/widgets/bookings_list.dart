import 'package:flutter/material.dart';
import 'booking_item.dart';

class BookingsList extends StatelessWidget {
  const BookingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        BookingItem(
          name: 'Bhusan Shrestha',
          service: 'Electrician • Completed',
          price: 'Rs. 1500',
          date: 'Oct 25',
          color: Colors.amber,
        ),
        BookingItem(
          name: 'Sita Tamang',
          service: 'House Cleaning • In progress',
          price: 'Rs. 800',
          date: 'Today',
          color: Colors.green,
        ),
      ],
    );
  }
}
