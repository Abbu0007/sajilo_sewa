import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/create_booking_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_service_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_top_rated_providers_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_notifications_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/mark_notification_read_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/create_rating_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/view_model/favourites_controller.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/notifications_sheet.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/service/booking_sheet.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/service/provider_details_sheet.dart';
import '../view_model/dashboard_home_controller.dart';
import '../view_model/home_notifications_controller.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/home_promo_card.dart';
import '../widgets/home/home_search_box.dart';
import '../widgets/home/home_section_header.dart';
import '../widgets/home/home_service_tile.dart';
import '../widgets/home/home_services_grid.dart';
import '../widgets/home/home_provider_row.dart';
import '../widgets/home/home_state_boxes.dart';
import 'service_providers_screen.dart';

class HomeScreen extends StatefulWidget {
  final DashboardRepositoryImpl repo;
  final FavouritesController favController;
  final CreateBookingUseCase createBooking;

  const HomeScreen({
    super.key,
    required this.repo,
    required this.favController,
    required this.createBooking,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final DashboardHomeController homeController;
  late final HomeNotificationsController notifController;

  DashboardRepositoryImpl get repo => widget.repo;
  FavouritesController get favController => widget.favController;
  CreateBookingUseCase get createBooking => widget.createBooking;

  @override
  void initState() {
    super.initState();

    homeController = DashboardHomeController(
      getServices: GetServicesUseCase(repo),
      getTopRatedProviders: GetTopRatedProvidersUseCase(repo),
    );

    notifController = HomeNotificationsController(
      getNotifications: GetNotificationsUseCase(repo),
      markRead: MarkNotificationReadUseCase(repo),
      createRating: CreateRatingUseCase(repo),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await homeController.load();
      await notifController.load();
    });
  }

  @override
  void dispose() {
    homeController.dispose();
    notifController.dispose();
    super.dispose();
  }

  String? _serviceIdFromSlug(String slug) {
    final s = slug.trim().toLowerCase();
    for (final svc in homeController.services) {
      if ((svc.slug ?? "").trim().toLowerCase() == s) return svc.id;
    }
    return null;
  }

  Future<void> _openNotifications() async {
    await notifController.load();
    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.75,
        child: HomeNotificationsSheet(controller: notifController),
      ),
    );

    if (!mounted) return;
    await homeController.load();
    await notifController.load();
  }

  Future<void> _openBookingSheet({
    required String providerId,
    required String serviceId,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.75,
        child: BookingSheet(
          onConfirm: (scheduledAt, address, note) async {
            await createBooking(
              providerId: providerId,
              serviceId: serviceId,
              scheduledAt: scheduledAt,
              addressText: address,
              note: note,
            );
          },
        ),
      ),
    );
  }

  Future<void> _openProviderDetails(dynamic p) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.62,
        child: ProviderDetailsSheet(
          provider: p,
          isFavourite: favController.isFavourite(p.id),
          onToggleFavourite: () async {
            await favController.toggle(p.id);
          },
          onBook: () async {
            final serviceId = _serviceIdFromSlug(p.serviceSlug ?? "");
            if (serviceId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Service not found for this provider.")),
              );
              return;
            }
            Navigator.pop(context);
            await _openBookingSheet(providerId: p.id, serviceId: serviceId);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([homeController, notifController, favController]),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await homeController.load();
                await notifController.load();
                await favController.load();
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                children: [
                  HomeHeader(
                    title: "Sajilo Sewa",
                    subtitle: "Kathmandu, Nepal",
                    unreadCount: notifController.unreadCount,
                    onTapNotifications: _openNotifications,
                  ),
                  const SizedBox(height: 14),

                  HomeSearchBox(
                    hint: "Search for services...",
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 14),

                  HomePromoCard(
                    title: "Get 20% Off",
                    subtitle: "On your first service booking",
                    buttonText: "Book Now",
                    onTap: () {},
                  ),
                  const SizedBox(height: 18),

                  HomeSectionHeader(
                    title: "All Services",
                    actionText: "View All",
                    onAction: () {},
                  ),
                  const SizedBox(height: 12),

                  if (homeController.loading && homeController.services.isEmpty)
                    const HomeLoadingBox(height: 160)
                  else if (homeController.error != null && homeController.services.isEmpty)
                    HomeErrorBox(message: homeController.error!, onRetry: homeController.load)
                  else
                    HomeServicesGrid(
                      itemCount: homeController.homeServices.length,
                      itemBuilder: (index) {
                        final s = homeController.homeServices[index];
                        return HomeServiceTile(
                          name: s.name,
                          slug: s.slug,
                          priceFrom: (s.basePriceFrom ?? 0).toInt(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ServiceProvidersScreen(
                                  repo: repo,
                                  favController: favController,
                                  createBooking: createBooking,
                                  slug: s.slug,
                                  title: s.name,
                                  serviceId: s.id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                  const SizedBox(height: 18),

                  HomeSectionHeader(
                    title: "Top Rated Providers",
                    actionText: "View All",
                    onAction: () {},
                  ),
                  const SizedBox(height: 12),

                  if (homeController.loading && homeController.topRated.isEmpty)
                    const HomeLoadingBox(height: 200)
                  else if (homeController.error != null && homeController.topRated.isEmpty)
                    HomeErrorBox(message: homeController.error!, onRetry: homeController.load)
                  else if (homeController.topRated.isEmpty)
                    const HomeEmptyBox(text: "No top-rated providers yet.")
                  else
                    Column(
                      children: homeController.topRated.map((p) {
                        return HomeProviderRow(
                          name: p.fullName,
                          profession: p.profession,
                          avatarUrl: p.avatarUrl,
                          avgRating: p.avgRating,
                          ratingCount: p.ratingCount,
                          completedJobs: p.completedJobs,
                          startingPrice: p.startingPrice,
                          onTap: () => _openProviderDetails(p),
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