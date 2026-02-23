import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/dashboard/data/datasources/remote/daashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/get_providers_by_service_usecase.dart';
import '../../domain/usecases/toggle_favourite_usecase.dart';
import '../view_model/service_providers_controller.dart';
import '../widgets/service/booking_sheet.dart';
import '../widgets/service/provider_card.dart';
import '../widgets/service/provider_details_sheet.dart';

class ServiceProvidersScreen extends StatefulWidget {
  final String slug;
  final String title;
  final String serviceId;

  const ServiceProvidersScreen({
    super.key,
    required this.slug,
    required this.title,
    required this.serviceId,
  });

  @override
  State<ServiceProvidersScreen> createState() => _ServiceProvidersScreenState();
}

class _ServiceProvidersScreenState extends State<ServiceProvidersScreen> {
  late final ServiceProvidersController controller;
  late final CreateBookingUseCase createBooking;

  @override
  void initState() {
    super.initState();

    final repo = DashboardRepositoryImpl(
      remote: DashboardRemoteDataSource(),
    );

    controller = ServiceProvidersController(
      getProviders: GetProvidersByServiceUseCase(repo),
      toggleFavourite: ToggleFavouriteUseCase(repo),
    );

    createBooking = CreateBookingUseCase(repo);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.load(widget.slug);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _openBookingSheet({required String providerId}) async {
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
              serviceId: widget.serviceId,
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
    required dynamic provider, // ProviderEntity
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
          isFavourite: controller.isFavourite(provider.id),
          onToggleFavourite: () => controller.toggle(provider.id),
          onBook: () {
            Navigator.pop(context);
            _openBookingSheet(providerId: provider.id);
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
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: controller.loading
              ? const Center(child: CircularProgressIndicator())
              : controller.error != null
                  ? Center(child: Text(controller.error!))
                  : controller.providers.isEmpty
                      ? const Center(child: Text("No providers available"))
                      : ListView(
                          padding: const EdgeInsets.all(16),
                          children: controller.providers.map((p) {
                            return ProviderCard(
                              provider: p,
                              isFavourite: controller.isFavourite(p.id),
                              onFavourite: () => controller.toggle(p.id),

                              onViewDetails: () => _openProviderDetailsSheet(provider: p),
                              onBookNow: () => _openBookingSheet(providerId: p.id),
                            );
                          }).toList(),
                        ),
        );
      },
    );
  }
}