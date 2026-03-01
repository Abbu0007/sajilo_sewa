import 'package:flutter/material.dart';

import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/get_providers_by_service_usecase.dart';
import '../view_model/favourites_controller.dart';
import '../view_model/service_providers_controller.dart';

import '../widgets/service/booking_sheet.dart';
import '../widgets/service/provider_card.dart';
import '../widgets/service/provider_details_sheet.dart';

class ServiceProvidersScreen extends StatefulWidget {
  final DashboardRepositoryImpl repo;
  final FavouritesController favController;
  final CreateBookingUseCase createBooking;

  final String slug;
  final String title;
  final String serviceId;

  const ServiceProvidersScreen({
    super.key,
    required this.repo,
    required this.favController,
    required this.createBooking,
    required this.slug,
    required this.title,
    required this.serviceId,
  });

  @override
  State<ServiceProvidersScreen> createState() => _ServiceProvidersScreenState();
}

class _ServiceProvidersScreenState extends State<ServiceProvidersScreen> {
  late final ServiceProvidersController controller;

  DashboardRepositoryImpl get repo => widget.repo;
  FavouritesController get favController => widget.favController;
  CreateBookingUseCase get createBooking => widget.createBooking;

  @override
  void initState() {
    super.initState();

    controller = ServiceProvidersController(
    getProviders: GetProvidersByServiceUseCase(repo),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.load(widget.slug);
      if (favController.favIds.isEmpty) {
        await favController.load();
      }
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
          isFavourite: favController.isFavourite(provider.id),
          onToggleFavourite: () async {
            await favController.toggle(provider.id);
          },
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
      animation: Listenable.merge([controller, favController]),
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
                              isFavourite: favController.isFavourite(p.id),
                              onFavourite: () => favController.toggle(p.id),
                              onViewDetails: () =>
                                  _openProviderDetailsSheet(provider: p),
                              onBookNow: () => _openBookingSheet(providerId: p.id),
                            );
                          }).toList(),
                        ),
        );
      },
    );
  }
}