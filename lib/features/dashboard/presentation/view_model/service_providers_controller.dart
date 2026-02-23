import 'package:flutter/foundation.dart';
import '../../domain/entities/provider_entity.dart';
import '../../domain/usecases/get_providers_by_service_usecase.dart';
import '../../domain/usecases/toggle_favourite_usecase.dart';

class ServiceProvidersController extends ChangeNotifier {
  final GetProvidersByServiceUseCase getProviders;
  final ToggleFavouriteUseCase toggleFavourite;

  ServiceProvidersController({
    required this.getProviders,
    required this.toggleFavourite,
  });

  bool loading = false;
  String? error;

  List<ProviderEntity> providers = [];

  final Set<String> favouriteIds = {};

  Future<void> load(String slug) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      providers = await getProviders(slug);
    } catch (e) {
      error = e.toString().replaceFirst("Exception: ", "");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  bool isFavourite(String providerId) {
    return favouriteIds.contains(providerId);
  }

  Future<void> toggle(String providerId) async {
    try {
      final isFav = await toggleFavourite(providerId);
      if (isFav) {
        favouriteIds.add(providerId);
      } else {
        favouriteIds.remove(providerId);
      }
      notifyListeners();
    } catch (_) {
      // silent
    }
  }
}