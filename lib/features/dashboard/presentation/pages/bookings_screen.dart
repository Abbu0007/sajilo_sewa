import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/dashboard/data/datasources/remote/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/usecases/get_my_bookings_usecase.dart';
import '../view_model/bookings_controller.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  late final BookingsController controller;

  @override
  void initState() {
    super.initState();

    final repo = DashboardRepositoryImpl(remote: DashboardRemoteDataSource());
    controller = BookingsController(getMyBookings: GetMyBookingsUseCase(repo));

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
      return "$y-$m-$d  $hh:$mm";
    } catch (_) {
      return iso;
    }
  }

  Color _statusBg(String status) {
    final s = status.trim().toLowerCase();
    if (s == "pending") return const Color(0xFFFEF3C7); 
    if (s == "accepted") return const Color(0xFFDBEAFE); 
    if (s == "completed") return const Color(0xFFD1FAE5); 
    if (s == "cancelled" || s == "canceled") return const Color(0xFFFEE2E2); 
    if (s == "rejected") return const Color(0xFFFEE2E2);
    return const Color(0xFFF3F4F6); // gray-100
  }

  Color _statusText(String status) {
    final s = status.trim().toLowerCase();
    if (s == "pending") return const Color(0xFF92400E); 
    if (s == "accepted") return const Color(0xFF1D4ED8); 
    if (s == "completed") return const Color(0xFF047857); 
    if (s == "cancelled" || s == "canceled") return const Color(0xFFB91C1C); 
    if (s == "rejected") return const Color(0xFFB91C1C);
    return const Color(0xFF334155); // slate-700
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
                              "Track all your service bookings.",
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      _StatusDropdown(
                        value: controller.status,
                        onChanged: (v) => controller.load(newStatus: v),
                      ),
                    ],
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
                      title: "No bookings yet",
                      subtitle: "Book a provider from Home or Services.",
                    )
                  else
                    ...controller.items.map((b) {
                      final serviceName = b.service?.name ?? "Service";
                      final providerName = b.provider?.fullName ?? "Provider";
                      final status = (b.status.isEmpty ? "unknown" : b.status);

                      return Container(
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
                                    status,
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

                            _InfoRow(
                              label: "When:",
                              value: _formatDate(b.scheduledAt),
                            ),
                            if ((b.addressText ?? "").trim().isNotEmpty) ...[
                              const SizedBox(height: 6),
                              _InfoRow(label: "Address:", value: b.addressText!.trim()),
                            ],
                            if ((b.note ?? "").trim().isNotEmpty) ...[
                              const SizedBox(height: 6),
                              _InfoRow(label: "Note:", value: b.note!.trim()),
                            ],
                          ],
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

class _StatusDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _StatusDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = const <String>[
      "all",
      "pending",
      "accepted",
      "completed",
      "cancelled",
      "rejected",
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFFF8FAFC),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : "all",
          borderRadius: BorderRadius.circular(14),
          items: items
              .map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(
                    s,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

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