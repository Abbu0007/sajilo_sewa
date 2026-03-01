import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_booking_entity.dart';

class AdminBookingCard extends StatelessWidget {
  final AdminBookingEntity booking;
  final VoidCallback onTap;

  const AdminBookingCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final serviceName = booking.service?.name ?? 'Service';
    final clientName = booking.client?.fullName ?? 'Client';
    final providerName = booking.provider?.fullName ?? 'Provider';
    final dateText = booking.scheduledAt == null
        ? '—'
        : '${booking.scheduledAt!.year}-${booking.scheduledAt!.month.toString().padLeft(2, '0')}-${booking.scheduledAt!.day.toString().padLeft(2, '0')}'
          '  ${booking.scheduledAt!.hour.toString().padLeft(2, '0')}:${booking.scheduledAt!.minute.toString().padLeft(2, '0')}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: scheme.surface,
            border: Border.all(color: Colors.black.withOpacity(0.06)),
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                offset: const Offset(0, 6),
                color: Colors.black.withOpacity(0.05),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      serviceName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _StatusPill(status: booking.status),
                ],
              ),
              const SizedBox(height: 10),

              _Row(label: 'Client', value: clientName),
              const SizedBox(height: 6),
              _Row(label: 'Provider', value: providerName),
              const SizedBox(height: 6),
              _Row(label: 'Scheduled', value: dateText),

              const SizedBox(height: 10),

              Row(
                children: [
                  _MiniPill(
                    icon: Icons.payments_outlined,
                    text: 'Rs ${booking.price.toStringAsFixed(0)}',
                  ),
                  const SizedBox(width: 8),
                  _MiniPill(
                    icon: Icons.verified_outlined,
                    text: booking.paymentStatus,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final muted = Colors.grey.shade700;
    return Row(
      children: [
        SizedBox(
          width: 78,
          child: Text(label, style: TextStyle(color: muted, fontWeight: FontWeight.w800)),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _MiniPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.black.withOpacity(0.04),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final s = status.trim().toLowerCase();

    Color bg;
    Color fg;

    if (s == 'pending') {
      bg = const Color(0xFFFFF7ED);
      fg = const Color(0xFF9A3412);
    } else if (s == 'confirmed') {
      bg = const Color(0xFFE0F2FE);
      fg = const Color(0xFF075985);
    } else if (s == 'in_progress') {
      bg = const Color(0xFFEDE9FE);
      fg = const Color(0xFF5B21B6);
    } else if (s == 'completed') {
      bg = const Color(0xFFECFDF5);
      fg = const Color(0xFF047857);
    } else if (s == 'cancelled') {
      bg = const Color(0xFFFFEBEE);
      fg = const Color(0xFFC62828);
    } else {
      bg = Colors.black.withOpacity(0.06);
      fg = Colors.black87;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: bg,
        border: Border.all(color: fg.withOpacity(0.18)),
      ),
      child: Text(
        s,
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: fg),
      ),
    );
  }
}