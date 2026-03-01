import 'package:flutter/foundation.dart';
import '../../domain/entities/provider_entity.dart';
import '../../domain/usecases/get_providers_by_service_usecase.dart';

class ServiceProvidersController extends ChangeNotifier {
  final GetProvidersByServiceUseCase getProviders;

  ServiceProvidersController({
    required this.getProviders,
  });

  bool loading = false;
  String? error;

  List<ProviderEntity> providers = [];

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
}