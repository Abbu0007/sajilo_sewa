import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/dashboard/data/datasources/remote/daashboard_remote_datasource.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_service_usecase.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/get_favourites_usecase.dart';
import '../../domain/usecases/toggle_favourite_usecase.dart';
import '../view_model/favourites_controller.dart';
import '../widgets/service/provider_card.dart';
import '../widgets/service/provider_details_sheet.dart';
import '../widgets/service/booking_sheet.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late final FavouritesController controller;
  late final CreateBookingUseCase createBooking;

  @override
  void initState() {
    super.initState();

    final repo = DashboardRepositoryImpl(remote: DashboardRemoteDataSource());

    controller = FavouritesController(
      getFavourites: GetFavouritesUseCase(repo),
      getServices: GetServicesUseCase(repo),
      toggleFavourite: ToggleFavouriteUseCase(repo),
    );

    createBooking = CreateBookingUseCase(repo);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.load();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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

  Future<void> _openProviderDetailsSheet({
    required dynamic provider, 
    required String? serviceId,
  }) async {
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
          provider: provider,
          isFavourite: true, 
          onToggleFavourite: () async {
            await controller.removeFavourite(provider.id);
            if (mounted) Navigator.pop(context);
          },
          onBook: () {
            Navigator.pop(context);
            if (serviceId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Service not found for this provider.")),
              );
              return;
            }
            _openBookingSheet(providerId: provider.id, serviceId: serviceId);
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
              onRefresh: controller.load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                children: [
                  const Text(
                    "Favourites",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Your favourite providers.",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 14),

                  if (controller.loading)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ))
                  else if (controller.error != null)
                    Container(
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
                              controller.error!,
                              style: const TextStyle(
                                color: Color(0xFF991B1B),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: controller.load,
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    )
                  else if (controller.items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "No favourites yet",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w800),
                      ),
                    )
                  else
                    ...controller.items.map((p) {
                      final serviceId = controller.serviceIdForProvider(p);

                      return ProviderCard(
                        provider: p,
                        isFavourite: true,
                        onFavourite: () => controller.removeFavourite(p.id),

                        onViewDetails: () => _openProviderDetailsSheet(
                          provider: p,
                          serviceId: serviceId,
                        ),

                        onBookNow: () {
                          if (serviceId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Service not found for this provider.")),
                            );
                            return;
                          }
                          _openBookingSheet(providerId: p.id, serviceId: serviceId);
                        },
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