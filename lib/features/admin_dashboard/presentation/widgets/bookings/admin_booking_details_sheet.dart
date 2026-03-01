import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_booking_entity.dart';

class AdminBookingDetailsSheet extends StatefulWidget {
  final AdminBookingEntity booking;
  final Future<void> Function(String reason) onCancel;
  final Future<void> Function() onDelete;

  const AdminBookingDetailsSheet({
    super.key,
    required this.booking,
    required this.onCancel,
    required this.onDelete,
  });

  @override
  State<AdminBookingDetailsSheet> createState() => _AdminBookingDetailsSheetState();
}

class _AdminBookingDetailsSheetState extends State<AdminBookingDetailsSheet> {
  bool _working = false;

  Future<void> _cancelFlow() async {
    final reason = await _askReason(context);
    if (reason == null) return;

    setState(() => _working = true);
    try {
      await widget.onCancel(reason);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;

    final service = b.service?.name ?? 'Service';
    final dateText = b.scheduledAt == null
        ? '—'
        : '${b.scheduledAt!.year}-${b.scheduledAt!.month.toString().padLeft(2, '0')}-${b.scheduledAt!.day.toString().padLeft(2, '0')}'
          '  ${b.scheduledAt!.hour.toString().padLeft(2, '0')}:${b.scheduledAt!.minute.toString().padLeft(2, '0')}';

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 6,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(service, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                  ),
                  const SizedBox(width: 10),
                  _StatusPill(status: b.status),
                ],
              ),
              const SizedBox(height: 10),

              _Section(
                title: 'Booking',
                children: [
                  _Line('ID', b.id),
                  _Line('Scheduled', dateText),
                  _Line('Payment', b.paymentStatus),
                  _Line('Price', 'Rs ${b.price.toStringAsFixed(0)}'),
                  if (b.addressText.trim().isNotEmpty) _Line('Address', b.addressText),
                  if (b.note.trim().isNotEmpty) _Line('Note', b.note),
                ],
              ),
              const SizedBox(height: 12),

              _Section(
                title: 'Client',
                children: [
                  _Line('Name', b.client?.fullName ?? '—'),
                  _Line('Phone', b.client?.phone ?? '—'),
                  _Line('Email', b.client?.email ?? '—'),
                  _Line('Rating', '${b.client?.ratingAvg.toStringAsFixed(1) ?? '0.0'} (${b.client?.ratingCount ?? 0})'),
                  _Line('Completed', '${b.client?.completedBookings ?? 0}'),
                ],
              ),
              const SizedBox(height: 12),

              _Section(
                title: 'Provider',
                children: [
                  _Line('Name', b.provider?.fullName ?? '—'),
                  _Line('Phone', b.provider?.phone ?? '—'),
                  _Line('Email', b.provider?.email ?? '—'),
                  _Line('Rating', '${b.provider?.ratingAvg.toStringAsFixed(1) ?? '0.0'} (${b.provider?.ratingCount ?? 0})'),
                  _Line('Completed', '${b.provider?.completedBookings ?? 0}'),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _working ? null : widget.onDelete,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w900)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: (_working || !b.canCancel) ? null : _cancelFlow,
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w900)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),

              if (!b.canCancel)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'This booking cannot be cancelled (completed/rejected/cancelled).',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _askReason(BuildContext context) async {
    final c = TextEditingController();

    final res = await showDialog<String?>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel booking'),
        content: TextField(
          controller: c,
          decoration: const InputDecoration(
            hintText: 'Reason (optional)',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, null), child: const Text('Close')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, c.text.trim()),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );

    return res;
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final String label;
  final String value;

  const _Line(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final muted = Colors.grey.shade700;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 86,
            child: Text(label, style: TextStyle(color: muted, fontWeight: FontWeight.w800)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
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