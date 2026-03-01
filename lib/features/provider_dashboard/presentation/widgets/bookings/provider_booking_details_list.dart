import 'package:flutter/material.dart';
import '../../../domain/entities/provider_booking_entity.dart';
import 'provider_booking_detail_tile.dart';

class ProviderBookingDetailsList extends StatelessWidget {
  final ProviderBookingEntity booking;
  const ProviderBookingDetailsList({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final client = booking.client;

    String v(String? s) => (s ?? "").trim().isEmpty ? "-" : s!.trim();

    return Column(
      children: [
        ProviderBookingDetailTile(
          icon: Icons.event,
          title: "Date & Time",
          value: booking.prettyDateTime,
        ),
        ProviderBookingDetailTile(
          icon: Icons.location_on_outlined,
          title: "Address",
          value: v(booking.addressText),
        ),
        ProviderBookingDetailTile(
          icon: Icons.phone,
          title: "Phone",
          value: v(client?.phone),
        ),
        ProviderBookingDetailTile(
          icon: Icons.email_outlined,
          title: "Email",
          value: v(client?.email),
        ),
        ProviderBookingDetailTile(
          icon: Icons.payments_outlined,
          title: "Payment",
          value: v(booking.paymentStatus),
        ),
        ProviderBookingDetailTile(
          icon: Icons.notes_rounded,
          title: "Note",
          value: v(booking.note),
        ),
      ],
    );
  }
}