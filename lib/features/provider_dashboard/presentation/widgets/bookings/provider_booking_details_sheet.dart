import 'package:flutter/material.dart';
import '../../../domain/entities/provider_booking_entity.dart';

class ProviderBookingDetailsSheet extends StatelessWidget {
  final ProviderBookingEntity booking;

  final bool busy;

  final Future<void> Function()? onAccept;
  final Future<void> Function(String reason)? onReject;

  final Future<void> Function()? onMarkInProgress;
  final Future<void> Function()? onMarkCompleted;
  final Future<void> Function(String reason)? onCancel;

  const ProviderBookingDetailsSheet({
    super.key,
    required this.booking,
    required this.busy,
    this.onAccept,
    this.onReject,
    this.onMarkInProgress,
    this.onMarkCompleted,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final client = booking.client;
    final clientName = client?.fullName ?? "Client";
    final serviceName = booking.service?.name ?? "Service";

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
                Expanded(
                  child: Text(
                    "Booking Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: busy ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Header card
            Container(
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
                  _AvatarCircle(
                    avatarUrl: client?.avatarUrl,
                    name: clientName,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clientName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          serviceName,
                          style: const TextStyle(
                            color: Color(0xFFE5E7EB),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _Pill(status: booking.status),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: [
                  _DetailTile(
                    icon: Icons.event,
                    title: "Date & Time",
                    value: booking.prettyDateTime ?? booking.scheduledAt,
                  ),
                  _DetailTile(
                    icon: Icons.location_on_outlined,
                    title: "Address",
                    value: (booking.addressText ?? "").trim().isEmpty
                        ? "-"
                        : booking.addressText!.trim(),
                  ),
                  _DetailTile(
                    icon: Icons.phone,
                    title: "Phone",
                    value: (client?.phone ?? "").trim().isEmpty ? "-" : client!.phone!.trim(),
                  ),
                  _DetailTile(
                    icon: Icons.email_outlined,
                    title: "Email",
                    value: (client?.email ?? "").trim().isEmpty ? "-" : client!.email!.trim(),
                  ),
                  _DetailTile(
                    icon: Icons.payments_outlined,
                    title: "Payment",
                    value: (booking.paymentStatus ?? "").trim().isEmpty
                        ? "-"
                        : booking.paymentStatus!.trim(),
                  ),
                  _DetailTile(
                    icon: Icons.notes_rounded,
                    title: "Note",
                    value: (booking.note ?? "").trim().isEmpty ? "-" : booking.note!.trim(),
                  ),

                  const SizedBox(height: 12),

                  // Actions
                  if (onAccept != null || onReject != null)
                    _ActionBlock(
                      title: "Request Actions",
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: busy
                                  ? null
                                  : () async {
                                      final reason = await _askReason(
                                        context,
                                        title: "Reject booking",
                                        hint: "Reason (optional)",
                                      );
                                      if (reason == null) return;
                                      await onReject?.call(reason);
                                    },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFFCA5A5)),
                                foregroundColor: const Color(0xFF991B1B),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: busy
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text("Reject", style: TextStyle(fontWeight: FontWeight.w900)),
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
                              child: busy
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text("Accept", style: TextStyle(fontWeight: FontWeight.w900)),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (onMarkInProgress != null || onMarkCompleted != null || onCancel != null)
                    _ActionBlock(
                      title: "Update Status",
                      child: Column(
                        children: [
                          if (onMarkInProgress != null)
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
                          if (onMarkCompleted != null) ...[
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
                            const Text(
                              "When completed, rating request will go to both sides.",
                              style: TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w700),
                            ),
                          ],
                          if (onCancel != null) ...[
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: busy
                                    ? null
                                    : () async {
                                        final reason = await _askReason(
                                          context,
                                          title: "Cancel booking",
                                          hint: "Cancellation reason (optional)",
                                        );
                                        if (reason == null) return;
                                        await onCancel?.call(reason);
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<String?> _askReason(
    BuildContext context, {
    required String title,
    required String hint,
  }) async {
    final ctrl = TextEditingController();

    return showDialog<String?>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          content: TextField(
            controller: ctrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}

class _ActionBlock extends StatelessWidget {
  final String title;
  final Widget child;
  const _ActionBlock({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF374151)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(color: Color(0xFF374151), fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String status;
  const _Pill({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status) {
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

    final label = status.replaceAll("_", " ");

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

class _AvatarCircle extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  const _AvatarCircle({required this.avatarUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name.isEmpty
        ? "U"
        : name
            .split(RegExp(r"\s+"))
            .take(2)
            .map((e) => e.isNotEmpty ? e[0] : "")
            .join()
            .toUpperCase();

    // If you already have a NetworkImage helper elsewhere, swap it in.
    final hasAvatar = (avatarUrl ?? "").trim().isNotEmpty;

    return CircleAvatar(
      radius: 24,
      backgroundColor: const Color(0xFFF3F4F6),
      child: hasAvatar
          ? const Icon(Icons.person, color: Colors.grey)
          : Text(
              initials,
              style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black87),
            ),
    );
  }
}