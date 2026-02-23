import 'package:flutter/foundation.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_service_usecase.dart';
import '../../domain/entities/provider_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/usecases/get_top_rated_providers_usecase.dart';

class DashboardHomeController extends ChangeNotifier {
  final GetServicesUseCase getServices;
  final GetTopRatedProvidersUseCase getTopRatedProviders;

  DashboardHomeController({
    required this.getServices,
    required this.getTopRatedProviders,
  });

  bool loading = false;
  String? error;

  List<ServiceEntity> services = [];
  List<ProviderEntity> topRated = [];

  /// slug -> serviceId (needed for booking)
  final Map<String, String> serviceIdBySlug = {};

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final s = await getServices();
      services = s;

      serviceIdBySlug
        ..clear()
        ..addEntries(s.map((x) => MapEntry(x.slug, x.id)));

      // Always show exactly 6 services on Home (your requirement)
      // We'll keep the backend order; it matches your web order already.
      final p = await getTopRatedProviders(limit: 8);
      topRated = p;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  List<ServiceEntity> get homeServices {
    if (services.length <= 6) return services;
    return services.take(6).toList();
  }

  String? getServiceIdFromSlug(String? slug) {
    if (slug == null || slug.trim().isEmpty) return null;
    return serviceIdBySlug[slug];
  }
}