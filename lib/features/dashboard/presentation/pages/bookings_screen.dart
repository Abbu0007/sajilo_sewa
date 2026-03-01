import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/dashboard/data/datasources/remote/dashboard_remote_datasource.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/bookings/booking_details_sheet.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/usecases/get_my_bookings_usecase.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';
import '../../domain/usecases/confirm_payment_usecase.dart';
import '../view_model/bookings_controller.dart';


class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  late final BookingsController controller;

  static const statuses = <String>[
    "all",
    "pending",
    "confirmed",
    "in_progress",
    "awaiting_payment_confirmation",
    "completed",
    "cancelled",
  ];

  @override
  void initState() {
    super.initState();

    final repo = DashboardRepositoryImpl(remote: DashboardRemoteDataSource());

    controller = BookingsController(
      getMyBookings: GetMyBookingsUseCase(repo),
      cancelBooking: CancelBookingUseCase(repo),
      confirmPayment: ConfirmPaymentUseCase(repo),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.load(newStatus: "all");
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final y = dt.year.toString().padLeft(4, '0');
      final m = dt.month.toString().padLeft(2, '0');
      final d = dt.day.toString().padLeft(2, '0');
      final hh = dt.hour.toString().padLeft(2, '0');
      final mm = dt.minute.toString().padLeft(2, '0');
      return "$d/$m/$y, $hh:$mm";
    } catch (_) {
      return iso;
    }
  }

  Color _statusBg(String status) {
    final s = status.trim().toLowerCase();
    if (s == "pending") return const Color(0xFFFEF3C7);
    if (s == "confirmed") return const Color(0xFFDBEAFE);
    if (s == "in_progress") return const Color(0xFFE0E7FF);
    if (s == "awaiting_payment_confirmation") return const Color(0xFFFFEDD5);
    if (s == "completed") return const Color(0xFFD1FAE5);
    if (s == "cancelled") return const Color(0xFFFEE2E2);
    return const Color(0xFFF3F4F6);
  }

  Color _statusText(String status) {
    final s = status.trim().toLowerCase();
    if (s == "pending") return const Color(0xFF92400E);
    if (s == "confirmed") return const Color(0xFF1D4ED8);
    if (s == "in_progress") return const Color(0xFF3730A3);
    if (s == "awaiting_payment_confirmation") return const Color(0xFF9A3412);
    if (s == "completed") return const Color(0xFF047857);
    if (s == "cancelled") return const Color(0xFFB91C1C);
    return const Color(0xFF334155);
  }

  Future<void> _openDetails(dynamic booking) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.78,
        child: BookingDetailsSheet(
          booking: booking,
          onCancel: (bookingId, reason) async {
            await controller.doCancel(bookingId, reason: reason);
          },
          onConfirmPayment: (bookingId) async {
            await controller.doConfirmPayment(bookingId);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => controller.load(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My Bookings",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Track bookings by status.",
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          color: const Color(0xFFF8FAFC),
                        ),
                        child: Text(
                          "Total: ${controller.items.length}",
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ✅ Tabs like website
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: statuses.map((s) {
                        final selected = controller.status == s;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(
                              s.replaceAll("_", " "),
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: selected ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            selected: selected,
                            onSelected: (_) => controller.load(newStatus: s),
                            selectedColor: Theme.of(context).colorScheme.primary,
                            backgroundColor: const Color(0xFFF1F5F9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                              side: const BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (controller.loading)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (controller.error != null)
                    _ErrorBox(message: controller.error!, onRetry: controller.load)
                  else if (controller.items.isEmpty)
                    const _EmptyBox(
                      title: "No bookings found",
                      subtitle: "Try another status tab or book a provider from Home.",
                    )
                  else
                    ...controller.items.map((b) {
                      final serviceName = b.service?.name ?? "Service";
                      final providerName = b.provider?.fullName ?? "Provider";
                      final status = (b.status.isEmpty ? "unknown" : b.status);

                      return InkWell(
                        onTap: () => _openDetails(b),
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
                                color: Color(0x140F172A),
                                blurRadius: 18,
                                offset: Offset(0, 10),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "$serviceName  •  $providerName",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _statusBg(status),
                                      borderRadius: BorderRadius.circular(99),
                                      border: Border.all(color: const Color(0xFFE5E7EB)),
                                    ),
                                    child: Text(
                                      status.replaceAll("_", " "),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 11,
                                        color: _statusText(status),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              _InfoRow(label: "When:", value: _formatDate(b.scheduledAt)),
                              if ((b.addressText ?? "").trim().isNotEmpty) ...[
                                const SizedBox(height: 6),
                                _InfoRow(label: "Address:", value: b.addressText!.trim()),
                              ],
                              if ((b.note ?? "").trim().isNotEmpty) ...[
                                const SizedBox(height: 6),
                                _InfoRow(label: "Note:", value: b.note!.trim()),
                              ],

                              const SizedBox(height: 10),
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
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ---- widgets ----

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
        children: [
          TextSpan(
            text: "$label ",
            style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  final Future<void> Function({String? newStatus}) onRetry;

  const _ErrorBox({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCA5A5)),
        color: const Color(0xFFFEF2F2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFF991B1B), fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(
            onPressed: () => onRetry(),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyBox({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}