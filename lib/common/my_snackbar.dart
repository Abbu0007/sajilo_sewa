import 'package:flutter/material.dart';
import 'app_colors.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontFamily: 'Quicksand Medium'),
      ),
      backgroundColor: AppColors.primary,
    ),
  );
}
