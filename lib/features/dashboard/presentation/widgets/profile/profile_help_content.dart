import 'package:flutter/material.dart';

class HelpCenterContent extends StatelessWidget {
  const HelpCenterContent({super.key});

  @override
  Widget build(BuildContext context) {
    final subtitle = TextStyle(
      color: Colors.grey.shade600,
      fontWeight: FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Need Help?",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 8),

        Text(
          "If you experience any issues with bookings, payments, or your account, our support team is here to help.",
          style: subtitle,
        ),

        const SizedBox(height: 20),

        const Text(
          "Customer Support",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 12),

        _info(Icons.email_outlined, "Email", "dhamalaabhishek7@gmail.com"),

        const SizedBox(height: 10),

        _info(Icons.phone_outlined, "Phone", "+977-9861344894"),

        const SizedBox(height: 10),

        _info(Icons.location_on_outlined, "Address", "Baluwakhani, Kapan, Nepal"),

        const SizedBox(height: 24),

        const Text(
          "Support Hours",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 8),

        Text(
          "Monday – Saturday\n9:00 AM – 6:00 PM",
          style: subtitle,
        ),

        const SizedBox(height: 20),

        Text(
          "We usually respond to support requests within 24 hours.",
          style: subtitle,
        ),
      ],
    );
  }

  Widget _info(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 10),
        Text("$title: ", style: const TextStyle(fontWeight: FontWeight.w700)),
        Expanded(child: Text(value)),
      ],
    );
  }
}