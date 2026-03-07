import 'package:flutter/material.dart';

class TermsContent extends StatelessWidget {
  const TermsContent({super.key});

  @override
  Widget build(BuildContext context) {

    final text = TextStyle(color: Colors.grey.shade700);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Terms of Service",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),

        const SizedBox(height: 12),

        Text(
          "By using Sajilo Sewa, you agree to the following terms and conditions.",
          style: text,
        ),

        const SizedBox(height: 14),

        const Text(
          "Bookings",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 6),

        Text(
          "Users can book service providers through the application. Providers are responsible for delivering services professionally and on time.",
          style: text,
        ),

        const SizedBox(height: 14),

        const Text(
          "User Responsibilities",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 6),

        Text(
          "Users must provide accurate information and respect service providers during bookings.",
          style: text,
        ),

        const SizedBox(height: 14),

        const Text(
          "Platform Limitations",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 6),

        Text(
          "Sajilo Sewa acts as a platform connecting clients and providers and is not responsible for individual service outcomes.",
          style: text,
        ),
      ],
    );
  }
}