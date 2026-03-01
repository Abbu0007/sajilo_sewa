import 'package:flutter/foundation.dart';
import '../../domain/entities/provider_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/usecases/get_favourites_usecase.dart';
import '../../domain/usecases/toggle_favourite_usecase.dart';
import '../../domain/usecases/get_service_usecase.dart';

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
 
  final Set<String> favIds = {};

  final Map<String, String> serviceIdBySlug = {};

  bool isFavourite(String providerId) => favIds.contains(providerId);

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final List<ServiceEntity> services = await getServices();
      serviceIdBySlug
        ..clear()
        ..addEntries(
          services.map((s) => MapEntry((s.slug ?? '').trim(), s.id)),
        );

      final favs = await getFavourites();
      items = favs;

      favIds
        ..clear()
        ..addAll(favs.map((p) => p.id));
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

  Future<void> toggle(String providerId) async {
    error = null;

    final wasFav = favIds.contains(providerId);

    if (wasFav) {
      favIds.remove(providerId);
      items.removeWhere((x) => x.id == providerId);
    } else {
      favIds.add(providerId);
    }
    notifyListeners();

    try {
      final nowFav = await toggleFavourite(providerId);
      if (nowFav) {
        favIds.add(providerId);
        if (!wasFav) {
          await load();
        } else {
          notifyListeners();
        }
      } else {
        favIds.remove(providerId);
        items.removeWhere((x) => x.id == providerId);
        notifyListeners();
      }
    } catch (e) {
      if (wasFav) {
        favIds.add(providerId);
      } else {
        favIds.remove(providerId);
      }
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> removeFavourite(String providerId) async {
    await toggle(providerId);
  }
}