import 'package:flutter/material.dart';
import 'package:sajilo_sewa/core/constants/app_colors.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Get 20% Off',
            style: TextStyle(
              fontFamily: 'Quicksand Bold',
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'On your first service booking',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
            ),
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }
}
