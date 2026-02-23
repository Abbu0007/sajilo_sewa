import 'package:flutter/foundation.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_service_usecase.dart';
import '../../domain/entities/provider_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/usecases/get_favourites_usecase.dart';
import '../../domain/usecases/toggle_favourite_usecase.dart';

class FavouritesController extends ChangeNotifier {
  final GetFavouritesUseCase getFavourites;
  final GetServicesUseCase getServices;
  final ToggleFavouriteUseCase toggleFavourite;

  FavouritesController({
    required this.getFavourites,
    required this.getServices,
    required this.toggleFavourite,
  });

  bool loading = false;
  String? error;

  List<ProviderEntity> items = [];
  final Map<String, String> serviceIdBySlug = {}; // slug -> _id

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      // services needed for booking from favourites (slug -> id)
      final List<ServiceEntity> services = await getServices();
      serviceIdBySlug
        ..clear()
        ..addEntries(services.map((s) => MapEntry(s.slug, s.id)));

      final favs = await getFavourites();
      items = favs;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  String? serviceIdForProvider(ProviderEntity p) {
    final slug = (p.serviceSlug ?? '').trim();
    if (slug.isEmpty) return null;
    return serviceIdBySlug[slug];
  }

  /// Remove favourite from list instantly (like your web)
  Future<void> removeFavourite(String providerId) async {
    try {
      // toggle will remove on backend
      await toggleFavourite(providerId);

      items = items.where((x) => x.id != providerId).toList();
      notifyListeners();
    } catch (_) {
      // ignore for now (you can show toast later)
    }
  }
}