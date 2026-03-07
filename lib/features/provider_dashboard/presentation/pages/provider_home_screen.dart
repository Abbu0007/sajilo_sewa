import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/provider_dashboard/data/datasources/local/provider_local_datasource.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/widgets/home/provider_notifications_sheet.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/widgets/ratings/rate_user_sheet.dart';
import '../../data/datasources/remote/provider_remote_datasource.dart';
import '../../data/repositories/provider_repository_impl.dart';
import '../../domain/entities/provider_notification_entity.dart';
import '../../domain/usecases/create_rating_usecase.dart';
import '../../domain/usecases/get_provider_bookings_usecase.dart';
import '../../domain/usecases/get_provider_me_usecase.dart';
import '../../domain/usecases/get_provider_notifications_usecase.dart';
import '../../domain/usecases/mark_provider_notification_read_usecase.dart';
import '../view_model/provider_home_controller.dart';
import '../view_model/provider_notifications_controller.dart';
import '../widgets/home/provider_quick_actions.dart';
import '../widgets/home/provider_welcome_header.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  late final ProviderHomeController controller;
  late final ProviderNotificationsController notifController;
  late final CreateRatingUseCase createRating;

  @override
  void initState() {
    super.initState();

    final repo = ProviderRepositoryImpl(
      remote: ProviderRemoteDataSource(),
      local: ProviderLocalDataSourceImpl(),
    );

    controller = ProviderHomeController(
      getMe: GetProviderMeUseCase(repo),
      getBookings: GetProviderBookingsUseCase(repo),
    );

    notifController = ProviderNotificationsController(
      getNotifications: GetProviderNotificationsUseCase(repo),
      markRead: MarkProviderNotificationReadUseCase(repo),
    );

    createRating = CreateRatingUseCase(repo);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.load();
      await notifController.load();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    notifController.dispose();
    super.dispose();
  }

  Future<void> _openRatingFromNotification(ProviderNotificationEntity n) async {
    if (!n.isRatingRequest) return;

    final bookingId = (n.bookingId ?? '').trim();
    if (bookingId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot open rating.")),
      );
      return;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.62,
        child: RateUserSheet(
          title: "Rate your client",
          subtitle: "How was the experience with this client?",
          busy: false,
          onSubmit: (stars, comment) async {
            try {
              await createRating(
                bookingId: bookingId,
                stars: stars,
                comment: comment,
              );

              if (!mounted) return;
              Navigator.of(context).pop();
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Thanks! Rating submitted.")),
              );
            } catch (e) {
              String message = "Something went wrong";

              if (e is DioException) {
                final data = e.response?.data;
                if (data is Map && data['message'] != null) {
                  message = data['message'].toString();
                } else {
                  message = e.message ?? message;
                }
              } else {
                message = e.toString().replaceFirst("Exception: ", "");
              }

              if (!mounted) return;

              if (message.toLowerCase().contains("already")) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Already rated.")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Future<void> _openNotifications() async {
    await notifController.load();
    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.75,
        child: ProviderNotificationsSheet(
          controller: notifController,
          onTapNotification: (n) async {
            await _openRatingFromNotification(n);
          },
        ),
      ),
    );
  }

  Widget _bellWithBadge({required int unread, required VoidCallback onTap}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        if (unread > 0)
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE11D48),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Text(
                unread > 99 ? "99+" : "$unread",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tipBg = isDark ? const Color(0xFF161A22) : const Color(0xFFF9FAFB);
    final tipBorder = isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final tipText = isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151);

    return AnimatedBuilder(
      animation: Listenable.merge([controller, notifController]),
      builder: (_, __) {
        return RefreshIndicator(
          onRefresh: () async {
            await controller.load();
            await notifController.load();
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Provider Dashboard",
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  _bellWithBadge(
                    unread: notifController.unreadCount,
                    onTap: _openNotifications,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (controller.loading && controller.me == null)
                const _LoadingBox(height: 110)
              else if (controller.error != null && controller.me == null)
                _ErrorBox(
                  message: controller.error!,
                  onRetry: controller.load,
                )
              else
                ProviderWelcomeHeader(
                  firstName: controller.me?.firstName ?? "Provider",
                ),

              const SizedBox(height: 16),

              Text(
                "Quick Stats",
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),

              ProviderQuickActions(
                pending: controller.countPending,
                confirmed: controller.countConfirmed,
                inProgress: controller.countInProgress,
                completed: controller.countCompleted,
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: tipBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: tipBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: scheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Tip: Mark booking as completed only after finishing the service. Then rating request will go to both sides.",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: tipText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LoadingBox extends StatelessWidget {
  final double height;
  const _LoadingBox({required this.height});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161A22) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBox({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? const Color(0xFF2A1517) : const Color(0xFFFEF2F2),
        border: Border.all(
          color: isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFCA5A5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}