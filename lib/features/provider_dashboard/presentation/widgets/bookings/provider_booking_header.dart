import 'package:flutter/material.dart';
import '../../../domain/entities/provider_booking_entity.dart';
import 'provider_booking_avatar.dart';
import 'provider_booking_status_pill.dart';

class ProviderBookingHeader extends StatelessWidget {
  final ProviderBookingEntity booking;
  const ProviderBookingHeader({super.key, required this.booking});

  String _resolveAvatarUrl(String? url) {
    if (url == null) return "";
    final u = url.trim();
    if (u.isEmpty) return "";
    return u.replaceFirst("http://localhost:5000", "http://10.0.2.2:5000");
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final client = booking.client;
    final clientName = (client?.fullName ?? "Client").trim();
    final serviceName = (booking.service?.name ?? "Service").trim();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withOpacity(0.98),
            scheme.primary.withOpacity(0.72),
            const Color(0xFF0B1220),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ProviderBookingAvatar(
            avatarUrl: _resolveAvatarUrl(client?.avatarUrl),
            name: clientName,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clientName.isEmpty ? "Client" : clientName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  serviceName.isEmpty ? "Service" : serviceName,
                  style: const TextStyle(
                    color: Color(0xFFE5E7EB),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                ProviderBookingStatusPill(status: booking.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}