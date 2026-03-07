import 'package:flutter/material.dart';
import 'package:sajilo_sewa/core/utils/url_utils.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/bookings/confirm_payment_status.dart';
import '../../../domain/entities/booking_entity.dart';

class BookingDetailsSheet extends StatefulWidget {
  final BookingEntity booking;
  final Future<void> Function(String bookingId, String? reason) onCancel;
  final Future<void> Function(String bookingId) onConfirmPayment;

  const BookingDetailsSheet({
    super.key,
    required this.booking,
    required this.onCancel,
    required this.onConfirmPayment,
  });

  @override
  State<BookingDetailsSheet> createState() => _BookingDetailsSheetState();
}

class _BookingDetailsSheetState extends State<BookingDetailsSheet> {
  final reasonCtrl = TextEditingController();
  bool acting = false;

  @override
  void dispose() {
    reasonCtrl.dispose();
    super.dispose();
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final d = dt.day.toString().padLeft(2, '0');
      final m = dt.month.toString().padLeft(2, '0');
      final y = dt.year.toString().padLeft(4, '0');
      final hh = dt.hour.toString().padLeft(2, '0');
      final mm = dt.minute.toString().padLeft(2, '0');
      return "$d/$m/$y, $hh:$mm";
    } catch (_) {
      return iso;
    }
  }

  int _amountFromPrice(dynamic price) {
    if (price == null) return 0;
    if (price is int) return price;
    if (price is double) return price.round();
    if (price is String) {
      final v = double.tryParse(price.trim());
      return (v ?? 0).round();
    }
    return 0;
  }

  String _resolveAvatarUrl(String? url) {
    return UrlUtils.normalizeMediaUrl(url);
  }

  String _initials(String name) {
    final t = name.trim();
    if (t.isEmpty) return "U";
    final parts = t.split(RegExp(r"\s+")).where((e) => e.isNotEmpty).toList();
    final i1 = parts.isNotEmpty ? parts[0][0] : "U";
    final i2 = parts.length > 1 ? parts[1][0] : "";
    return ("$i1$i2").toUpperCase();
  }

  Future<void> _openConfirmPayment() async {
    if (acting) return;

    final outerContext = context;
    final b = widget.booking;
    final amount = _amountFromPrice(b.price);

    setState(() => acting = true);

    try {
      final paid = await showModalBottomSheet<bool>(
        context: outerContext,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        builder: (_) => FractionallySizedBox(
          heightFactor: 0.62,
          child: ConfirmPaymentSheet(
            amount: amount,
            onConfirmPaid: () async {
              await widget.onConfirmPayment(b.id);
            },
          ),
        ),
      );

      if (paid == true && mounted && Navigator.canPop(outerContext)) {
        Navigator.pop(outerContext);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
      );
    } finally {
      if (mounted) setState(() => acting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final title =
        "${b.service?.name ?? "Service"} • ${b.provider?.fullName ?? "Provider"}";
    final bookingId = b.id;

    final scheduledRaw = (b.scheduledAt ?? "").toString().trim();
    final whenText = scheduledRaw.isEmpty ? "-" : _formatDate(scheduledRaw);

    final addressRaw = (b.addressText ?? "").toString().trim();
    final address = addressRaw.isEmpty ? "-" : addressRaw;

    final noteRaw = (b.note ?? "").toString().trim();
    final note = noteRaw.isEmpty ? "-" : noteRaw;

    final status = (b.status ?? "pending").toString().trim();
    final payment = (b.paymentStatus ?? "unpaid").toString().trim();

    final canCancel = status == "pending" || status == "confirmed";
    final canConfirmPayment = status == "awaiting_payment_confirmation";

    final providerName = (b.provider?.fullName ?? "Provider").trim();
    final providerProfession = (b.provider?.profession ?? "Professional").trim();
    final avatar = _resolveAvatarUrl(b.provider?.avatarUrl);
    final hasAvatar = avatar.isNotEmpty;
    final initials = _initials(providerName);

    final handleColor =
        isDark ? const Color(0xFF4B5563) : Colors.grey.shade300;
    final topCardBg =
        isDark ? const Color(0xFF161A22) : const Color(0xFFF8FAFC);
    final topCardBorder =
        isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final avatarBg =
        isDark ? const Color(0xFF1B2230) : const Color(0xFFF3F4F6);
    final subText =
        isDark ? const Color(0xFF9CA3AF) : Colors.grey.shade700;
    final cancelBg =
        isDark ? const Color(0xFF2A1517) : const Color(0xFFFEF2F2);
    final cancelBorder =
        isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFCA5A5);
    final cancelTitle =
        isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 10,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 44,
              decoration: BoxDecoration(
                color: handleColor,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  onPressed: acting ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Booking ID: $bookingId",
                style: TextStyle(color: subText, fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: topCardBorder),
                color: topCardBg,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 72,
                      width: 72,
                      color: avatarBg,
                      child: hasAvatar
                          ? Image.network(
                              avatar,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Text(
                                  initials,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          providerName,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          providerProfession,
                          style: TextStyle(
                            color: subText,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _InfoGrid(
              items: [
                _InfoItem(label: "When", value: whenText, icon: Icons.calendar_month),
                _InfoItem(label: "Address", value: address, icon: Icons.place_outlined),
                _InfoItem(label: "Payment", value: payment, icon: Icons.payments_outlined),
                _InfoItem(label: "Status", value: status, icon: Icons.info_outline),
              ],
            ),
            const SizedBox(height: 12),
            _Box(label: "Note", value: note),
            const SizedBox(height: 14),
            if (canConfirmPayment)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: acting ? null : _openConfirmPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(acting ? "Processing..." : "Pay Now"),
                ),
              ),
            if (canCancel) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cancelBorder),
                  color: cancelBg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cancel booking",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: cancelTitle,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: reasonCtrl,
                      decoration: const InputDecoration(
                        hintText: "Reason (optional)",
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: acting
                            ? null
                            : () async {
                                setState(() => acting = true);
                                try {
                                  final r = reasonCtrl.text.trim().isEmpty
                                      ? null
                                      : reasonCtrl.text.trim();
                                  await widget.onCancel(bookingId, r);
                                  if (mounted) Navigator.pop(context);
                                } finally {
                                  if (mounted) setState(() => acting = false);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE11D48),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(acting ? "Cancelling..." : "Cancel"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: acting ? null : () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final List<_InfoItem> items;
  const _InfoGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items.map((i) => _Tile(item: i)).toList(),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;
  final IconData icon;
  _InfoItem({required this.label, required this.value, required this.icon});
}

class _Tile extends StatelessWidget {
  final _InfoItem item;
  const _Tile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF161A22) : Colors.white;
    final border =
        isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final iconColor =
        isDark ? const Color(0xFFD1D5DB) : Colors.grey.shade700;
    final labelColor =
        isDark ? const Color(0xFF9CA3AF) : Colors.grey.shade600;

    return Container(
      width: (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        color: bg,
      ),
      child: Row(
        children: [
          Icon(item.icon, size: 18, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: labelColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(item.value, style: const TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final String label;
  final String value;
  const _Box({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF161A22) : Colors.white;
    final border =
        isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final labelColor =
        isDark ? const Color(0xFF9CA3AF) : Colors.grey.shade600;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        color: bg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: labelColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}