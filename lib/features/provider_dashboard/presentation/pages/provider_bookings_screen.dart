import 'package:flutter/material.dart';

import 'package:sajilo_sewa/features/provider_dashboard/presentation/widgets/bookings/provider_booking_details_sheet.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/widgets/ratings/rate_user_sheet.dart';

import '../../data/datasources/remote/provider_remote_datasource.dart';
import '../../data/repositories/provider_repository_impl.dart';
import '../../domain/entities/provider_booking_entity.dart';
import '../../domain/usecases/accept_booking_usecase.dart';
import '../../domain/usecases/create_rating_usecase.dart';
import '../../domain/usecases/get_provider_bookings_usecase.dart';
import '../../domain/usecases/reject_booking_usecase.dart';
import '../../domain/usecases/update_booking_status_usecase.dart';
import '../view_model/provider_bookings_controller.dart';
import '../widgets/bookings/provider_booking_card.dart';

class ProviderBookingsScreen extends StatefulWidget {
  const ProviderBookingsScreen({super.key});

  @override
  State<ProviderBookingsScreen> createState() => _ProviderBookingsScreenState();
}

class _ProviderBookingsScreenState extends State<ProviderBookingsScreen> {
  late final ProviderBookingsController controller;

  final List<_StatusTab> _tabs = const [
    _StatusTab(label: "All", value: "all"),
    _StatusTab(label: "Pending", value: "pending"),
    _StatusTab(label: "Confirmed", value: "confirmed"),
    _StatusTab(label: "In Progress", value: "in_progress"),
    _StatusTab(label: "Completed", value: "completed"),
    _StatusTab(label: "Cancelled", value: "cancelled"),
  ];

  String _selectedStatus = "all";

  @override
  void initState() {
    super.initState();

    final repo = ProviderRepositoryImpl(remote: ProviderRemoteDataSource());

    controller = ProviderBookingsController(
      getBookings: GetProviderBookingsUseCase(repo),
      accept: AcceptBookingUseCase(repo),
      reject: RejectBookingUseCase(repo),
      updateStatus: UpdateBookingStatusUseCase(repo),
      createRating: CreateRatingUseCase(repo),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.load(status: _selectedStatus);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _openRatingSheet({
    required String bookingId,
    required String title,
    required String subtitle,
  }) async {
    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.62,
        child: RateUserSheet(
          title: title,
          subtitle: subtitle,
          busy: controller.actionBusy,
          onSubmit: (stars, comment) async {
            await controller.rate(
              bookingId: bookingId,
              stars: stars,
              comment: comment,
            );

            // if backend says already rated, show message
            final err = controller.error ?? "";
            if (!mounted) return;

            if (err.toLowerCase().contains("already rated") ||
                err.toLowerCase().contains("already rated this booking") ||
                err.toLowerCase().contains("you already rated")) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Already rated.")),
              );
            } else if (err.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(err)),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Thanks! Rating submitted.")),
              );
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  Future<void> _openDetails(ProviderBookingEntity b) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.88,
        child: ProviderBookingDetailsSheet(
          booking: b,
          busy: controller.actionBusy,
          onAccept: b.status == "pending"
              ? () async {
                  await controller.acceptBooking(b.id, reloadStatus: _selectedStatus);
                  if (mounted) Navigator.pop(context);
                }
              : null,
          onReject: b.status == "pending"
              ? (reason) async {
                  await controller.rejectBooking(
                    b.id,
                    reason: reason,
                    reloadStatus: _selectedStatus,
                  );
                  if (mounted) Navigator.pop(context);
                }
              : null,
          onMarkInProgress: (b.status == "confirmed")
              ? () async {
                  await controller.updateBookingStatus(
                    b.id,
                    statusValue: "in_progress",
                    reloadStatus: _selectedStatus,
                  );
                  if (mounted) Navigator.pop(context);
                }
              : null,

          
          onMarkCompleted: (b.status == "in_progress")
              ? () async {
                  await controller.updateBookingStatus(
                    b.id,
                    statusValue: "completed",
                    reloadStatus: _selectedStatus,
                  );

                  if (!mounted) return;

                  Navigator.pop(context);

                  
                  await _openRatingSheet(
                    bookingId: b.id,
                    title: "Rate your client",
                    subtitle: "How was the experience with this client?",
                  );
                }
              : null,

          onCancel: (b.status == "confirmed" || b.status == "in_progress")
              ? (reason) async {
                  await controller.updateBookingStatus(
                    b.id,
                    statusValue: "cancelled",
                    reason: reason,
                    reloadStatus: _selectedStatus,
                  );
                  if (mounted) Navigator.pop(context);
                }
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => controller.load(status: _selectedStatus),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Bookings",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: scheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: IconButton(
                          tooltip: "Refresh",
                          onPressed: controller.loading
                              ? null
                              : () => controller.load(status: _selectedStatus),
                          icon: Icon(Icons.refresh_rounded, color: scheme.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          scheme.primary.withOpacity(0.98),
                          scheme.primary.withOpacity(0.70),
                          const Color(0xFF0B1220),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 28,
                          offset: Offset(0, 16),
                          color: Color(0x22000000),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manage your bookings",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Accept requests, update status, and complete jobs.\nWhen completed, rating request will go to both sides.",
                          style: TextStyle(
                            color: Color(0xFFE5E7EB),
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _tabs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, i) {
                        final t = _tabs[i];
                        final selected = t.value == _selectedStatus;

                        return InkWell(
                          onTap: () async {
                            setState(() => _selectedStatus = t.value);
                            await controller.load(status: _selectedStatus);
                          },
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected ? scheme.primary : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: selected ? scheme.primary : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Text(
                              t.label,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: selected ? Colors.white : const Color(0xFF111827),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (controller.loading && controller.items.isEmpty)
                    const _LoadingBox()
                  else if (controller.error != null && controller.items.isEmpty)
                    _ErrorBox(
                      message: controller.error!,
                      onRetry: () => controller.load(status: _selectedStatus),
                    )
                  else if (controller.items.isEmpty)
                    const _EmptyBox()
                  else
                    Column(
                      children: controller.items.map((b) {
                        return ProviderBookingCard(
                          booking: b,
                          onViewDetails: () => _openDetails(b),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatusTab {
  final String label;
  final String value;
  const _StatusTab({required this.label, required this.value});
}

class _LoadingBox extends StatelessWidget {
  const _LoadingBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Row(
        children: [
          Icon(Icons.inbox_outlined, color: Color(0xFF6B7280)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "No bookings found for this status.",
              style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF374151)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBox({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFFEF2F2),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFF991B1B), fontWeight: FontWeight.w800),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}