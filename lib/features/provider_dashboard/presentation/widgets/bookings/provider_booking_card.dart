import 'package:flutter/material.dart';
import '../../../domain/entities/provider_booking_entity.dart';

class ProviderBookingCard extends StatelessWidget {
  final ProviderBookingEntity booking;
  final VoidCallback onViewDetails;

  const ProviderBookingCard({
    super.key,
    required this.booking,
    required this.onViewDetails,
  });

  String _resolveAvatarUrl(String? url) {
    if (url == null) return "";
    final u = url.trim();
    if (u.isEmpty) return "";
    // Android emulator uses 10.0.2.2 for host machine
    return u.replaceFirst("http://localhost:5000", "http://10.0.2.2:5000");
  }

  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return "U";
    final parts = trimmed.split(RegExp(r"\s+")).where((e) => e.isNotEmpty).toList();
    final i1 = parts.isNotEmpty ? parts[0][0] : "U";
    final i2 = parts.length > 1 ? parts[1][0] : "";
    return ("$i1$i2").toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final clientName = booking.client?.fullName ?? "Client";
    final serviceName = booking.service?.name ?? "Service";

    final avatar = _resolveAvatarUrl(booking.client?.avatarUrl);
    final hasAvatar = avatar.isNotEmpty;
    final initials = _initials(clientName);

    return InkWell(
      onTap: onViewDetails,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              offset: Offset(0, 10),
              color: Color(0x11000000),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFF3F4F6),
                  backgroundImage: hasAvatar ? NetworkImage(avatar) : null,
                  child: hasAvatar
                      ? null
                      : Text(
                          initials,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                ),
                const SizedBox(width: 12),

                // title + sub
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$serviceName • $clientName",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Tap to view details",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),
                _StatusPill(status: booking.status),
              ],
            ),

            const SizedBox(height: 12),

            _InfoRow(
              icon: Icons.event,
              text: booking.prettyDateTime ?? booking.scheduledAt,
            ),
            if ((booking.addressText ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              _InfoRow(icon: Icons.location_on_outlined, text: booking.addressText!.trim()),
            ],
            if ((booking.note ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              _InfoRow(icon: Icons.notes_rounded, text: booking.note!.trim()),
            ],

            const SizedBox(height: 12),

            // ✅ View details button still available
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onViewDetails,
                icon: Icon(Icons.info_outline, size: 18, color: scheme.primary),
                label: Text(
                  "View Details",
                  style: TextStyle(fontWeight: FontWeight.w900, color: scheme.primary),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

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

    final label = status.replaceAll("_", " ");

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: fg),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6B7280)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}