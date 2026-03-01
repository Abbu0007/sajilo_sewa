import 'package:flutter/material.dart';
import '../../../domain/entities/provider_booking_entity.dart';
import 'provider_booking_header.dart';
import 'provider_booking_details_list.dart';
import 'provider_booking_actions.dart';

class ProviderBookingDetailsSheet extends StatelessWidget {
  final ProviderBookingEntity booking;
  final bool busy;
  final Future<void> Function()? onAccept;
  final Future<void> Function(String? reason)? onReject;
  final Future<void> Function()? onMarkInProgress;
  final Future<void> Function(String price, String? reason)? onRequestPayment;
  final Future<void> Function()? onMarkCompleted;
  final Future<void> Function(String? reason)? onCancel;

  const ProviderBookingDetailsSheet({
    super.key,
    required this.booking,
    required this.busy,
    this.onAccept,
    this.onReject,
    this.onMarkInProgress,
    this.onRequestPayment,
    this.onMarkCompleted,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            Container(
              height: 5,
              width: 44,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Booking Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  onPressed: busy ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ProviderBookingHeader(booking: booking),

            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: [
                  ProviderBookingDetailsList(booking: booking),
                  const SizedBox(height: 12),
                  ProviderBookingActions(
                    booking: booking,
                    busy: busy,
                    onAccept: onAccept,
                    onReject: onReject,
                    onMarkInProgress: onMarkInProgress,
                    onRequestPayment: onRequestPayment,
                    onMarkCompleted: onMarkCompleted,
                    onCancel: onCancel,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}