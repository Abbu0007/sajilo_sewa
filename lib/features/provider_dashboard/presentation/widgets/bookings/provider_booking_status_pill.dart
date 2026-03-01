import 'package:flutter/material.dart';

class ProviderBookingStatusPill extends StatelessWidget {
  final String status;
  const ProviderBookingStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final s = status.trim().toLowerCase();

    Color bg;
    Color fg;

    switch (s) {
      case "pending":
        bg = const Color(0xFFFFFBEB);
        fg = const Color(0xFF92400E);
        break;
      case "confirmed":
        bg = const Color(0xFFEFF6FF);
        fg = const Color(0xFF1D4ED8);
        break;
      case "in_progress":
        bg = const Color(0xFFF5F3FF);
        fg = const Color(0xFF6D28D9);
        break;
      case "awaiting_payment_confirmation":
        bg = const Color(0xFFECFEFF);
        fg = const Color(0xFF0E7490);
        break;
      case "completed":
        bg = const Color(0xFFECFDF5);
        fg = const Color(0xFF065F46);
        break;
      case "cancelled":
      case "rejected":
        bg = const Color(0xFFFEF2F2);
        fg = const Color(0xFF991B1B);
        break;
      default:
        bg = const Color(0xFFF3F4F6);
        fg = const Color(0xFF374151);
    }

    final label = s.replaceAll("_", " ");

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x22FFFFFF)),
      ),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: fg),
      ),
    );
  }
}