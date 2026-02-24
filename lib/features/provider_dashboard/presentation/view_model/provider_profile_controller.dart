import 'package:flutter/foundation.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/upload__provider_avatar_usecase.dart';
import '../../domain/entities/provider_me_entity.dart';
import '../../domain/entities/provider_profile_entity.dart';
import '../../domain/usecases/get_provider_me_usecase.dart';
import '../../domain/usecases/get_provider_profile_usecase.dart';
import '../../domain/usecases/update_provider_profile_usecase.dart';


class ProviderProfileController extends ChangeNotifier {
  final GetProviderMeUseCase getMe;
  final GetProviderProfileUseCase getProfile;
  final UpdateProviderProfileUseCase updateProfile;
  final UploadProviderAvatarUseCase uploadAvatar;

  ProviderProfileController({
    required this.getMe,
    required this.getProfile,
    required this.updateProfile,
    required this.uploadAvatar,
  });

  bool loading = false;
  String? error;

  ProviderMeEntity? me;
  ProviderProfileEntity? profile;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      me = await getMe();
      profile = await getProfile();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfile({
    required String profession,
    String? bio,
    num? startingPrice,
    List<String>? serviceAreas,
    String? availability,
  }) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      profile = await updateProfile(
        profession: profession,
        bio: bio,
        startingPrice: startingPrice,
        serviceAreas: serviceAreas,
        availability: availability,
      );
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> uploadMyAvatar(String filePath) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      me = await uploadAvatar(filePath);
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}