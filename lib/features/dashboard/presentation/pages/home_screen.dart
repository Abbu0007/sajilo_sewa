import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/dashboard/data/datasources/remote/daashboard_remote_datasource.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_service_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/notifications_sheet.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/get_top_rated_providers_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
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
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final DashboardHomeController homeController;
  late final HomeNotificationsController notifController;

  @override
  void initState() {
    super.initState();

    final repo = DashboardRepositoryImpl(remote: DashboardRemoteDataSource());

    homeController = DashboardHomeController(
      getServices: GetServicesUseCase(repo),
      getTopRatedProviders: GetTopRatedProvidersUseCase(repo),
    );

    notifController = HomeNotificationsController(
      getNotifications: GetNotificationsUseCase(repo),
      markRead: MarkNotificationReadUseCase(repo),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await homeController.load();
      // Optional: preload notifications count so badge is correct
      await notifController.load();
    });
  }

  @override
  void dispose() {
    homeController.dispose();
    notifController.dispose();
    super.dispose();
  }

  Future<void> _openNotifications() async {
    // refresh when opened
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
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([homeController, notifController]),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await homeController.load();
                await notifController.load();
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
                    onChanged: (v) {
                      // later: connect search
                    },
                  ),
                  const SizedBox(height: 14),

                  HomePromoCard(
                    title: "Get 20% Off",
                    subtitle: "On your first service booking",
                    buttonText: "Book Now",
                    onTap: () {
                      // later: scroll to services or open all services
                    },
                  ),
                  const SizedBox(height: 18),

                  HomeSectionHeader(
                    title: "All Services",
                    actionText: "View All",
                    onAction: () {
                      // later: open all services screen
                    },
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
                    onAction: () {
                      // later: open provider list
                    },
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
                          profession: p.profession ?? "Professional",
                          avatarUrl: p.avatarUrl,
                          onTap: () {
                            // next step: provider details + booking bottom sheets
                          },
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