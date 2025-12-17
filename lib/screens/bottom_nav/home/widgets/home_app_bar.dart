import 'package:flutter/material.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/styles.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.home, color: Colors.white),
        ),
        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Sajilo Sewa', style: AppStyles.heading),
            Text('Kathmandu, Nepal', style: AppStyles.caption),
          ],
        ),

        const Spacer(),

        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        ),
        const CircleAvatar(radius: 16),
      ],
    );
  }
}
