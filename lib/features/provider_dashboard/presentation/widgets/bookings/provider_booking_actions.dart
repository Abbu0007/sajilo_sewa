import 'package:flutter/material.dart';
import '../../../domain/entities/provider_booking_entity.dart';
import 'provider_booking_action_block.dart';
import 'provider_booking_dialogs.dart';

class ProviderBookingActions extends StatelessWidget {
  final ProviderBookingEntity booking;
  final bool busy;

  final Future<void> Function()? onAccept;
  final Future<void> Function(String? reason)? onReject;
  final Future<void> Function()? onMarkInProgress;
  final Future<void> Function(String price, String? reason)? onRequestPayment;
  final Future<void> Function()? onMarkCompleted;
  final Future<void> Function(String? reason)? onCancel;

  const ProviderBookingActions({
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

  bool _is(String s, String v) => s.trim().toLowerCase() == v;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final helperTextColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    final status = booking.status.trim().toLowerCase();

    final canDecision = _is(status, "pending");
    final canInProgress = _is(status, "confirmed");
    final canRequestPayment = _is(status, "in_progress");
    final canComplete = _is(status, "awaiting_payment_confirmation") || _is(status, "in_progress");
    final canCancel = _is(status, "pending") || _is(status, "confirmed") || _is(status, "in_progress");

    final hasDecisionHandlers = onAccept != null || onReject != null;
    final hasUpdateHandlers =
        onMarkInProgress != null || onRequestPayment != null || onMarkCompleted != null || onCancel != null;

    return Column(
      children: [
        if (canDecision && hasDecisionHandlers)
          ProviderBookingActionBlock(
            title: "Request Actions",
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: busy
                        ? null
                        : () async {
                            final reason = await ProviderBookingDialogs.askReason(
                              context,
                              title: "Reject booking",
                              hint: "Reason (optional)",
                            );
                            if (reason == null) return;
                            await onReject?.call(reason.trim().isEmpty ? null : reason.trim());
                          },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFCA5A5)),
                      foregroundColor: const Color(0xFF991B1B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Reject", style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: busy ? null : () async => await onAccept?.call(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Accept", style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ),
              ],
            ),
          ),
        if (hasUpdateHandlers && (canInProgress || canRequestPayment || canComplete || canCancel))
          ProviderBookingActionBlock(
            title: "Update Status",
            child: Column(
              children: [
                if (canInProgress && onMarkInProgress != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: busy ? null : () async => await onMarkInProgress?.call(),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text("Mark In Progress", style: TextStyle(fontWeight: FontWeight.w900)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                if (canRequestPayment && onRequestPayment != null) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: busy
                          ? null
                          : () async {
                              final res = await ProviderBookingDialogs.askPriceAndReason(
                                context,
                                title: "Request Payment",
                                priceHint: "Enter total price (Rs.)",
                                reasonHint: "Note / reason (optional)",
                              );
                              if (res == null) return;
                              await onRequestPayment?.call(res.price, res.reason);
                            },
                      icon: const Icon(Icons.payments_outlined),
                      label: const Text("Request Payment", style: TextStyle(fontWeight: FontWeight.w900)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0EA5E9),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "This will move booking to awaiting payment confirmation.",
                    style: TextStyle(color: helperTextColor, fontWeight: FontWeight.w700),
                  ),
                ],
                if (canComplete && onMarkCompleted != null) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: busy ? null : () async => await onMarkCompleted?.call(),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text("Mark Completed", style: TextStyle(fontWeight: FontWeight.w900)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "When completed, rating request will go to both sides.",
                    style: TextStyle(color: helperTextColor, fontWeight: FontWeight.w700),
                  ),
                ],
                if (canCancel && onCancel != null) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: busy
                          ? null
                          : () async {
                              final reason = await ProviderBookingDialogs.askReason(
                                context,
                                title: "Cancel booking",
                                hint: "Cancellation reason (optional)",
                              );
                              if (reason == null) return;
                              await onCancel?.call(reason.trim().isEmpty ? null : reason.trim());
                            },
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text("Cancel Booking", style: TextStyle(fontWeight: FontWeight.w900)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFCA5A5)),
                        foregroundColor: const Color(0xFF991B1B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}