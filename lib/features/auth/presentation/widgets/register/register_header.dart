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
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: Colors.black,
                  ),
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

        const SizedBox(height: 16),

        // Icon circle
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5B4FFF), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person_add, size: 40, color: Colors.white),
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
