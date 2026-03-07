import 'package:flutter/material.dart';

class PrivacyPolicyContent extends StatelessWidget {
  const PrivacyPolicyContent({super.key});

  @override
  Widget build(BuildContext context) {

    final text = TextStyle(color: Colors.grey.shade700);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Privacy Policy",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),

        const SizedBox(height: 12),

        Text(
          "Sajilo Sewa respects your privacy and is committed to protecting your personal data.",
          style: text,
        ),

        const SizedBox(height: 14),

        const Text(
          "Information We Collect",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 6),

        Text(
          "• Name, phone number, and email address\n"
          "• Booking history\n"
          "• Service preferences\n"
          "• Profile information",
          style: text,
        ),

        const SizedBox(height: 14),

        const Text(
          "How We Use Your Information",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 6),

        Text(
          "Your information is used to process bookings, improve our services, and provide customer support.",
          style: text,
        ),

        const SizedBox(height: 14),

        const Text(
          "Data Security",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 6),

        Text(
          "We implement appropriate security measures to protect your data from unauthorized access or disclosure.",
          style: text,
        ),
      ],
    );
  }
}