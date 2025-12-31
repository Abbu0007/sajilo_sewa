import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Back Button + Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  size: 24,
                  color: Colors.black,
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // SAJILO SEWA LOGO
        Image.asset(
          'assets/images/sajilo_sewa_logo.png',
          height: 120, // 👈 increase/decrease if needed
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 24),

        const Text(
          'Create Account',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 8),

        const Text(
          'Join thousands of users and start your\njourney with us today',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF666666), height: 1.5),
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}
