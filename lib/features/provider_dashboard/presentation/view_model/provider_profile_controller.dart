import 'package:flutter/foundation.dart';
import '../../domain/entities/provider_me_entity.dart';
import '../../domain/entities/provider_profile_entity.dart';
import '../../domain/usecases/get_provider_me_usecase.dart';
import '../../domain/usecases/get_provider_profile_usecase.dart';
import '../../domain/usecases/get_provider_total_earnings_usecase.dart';
import '../../domain/usecases/update_provider_me_usecase.dart';
import '../../domain/usecases/update_provider_profile_usecase.dart';
import '../../domain/usecases/upload__provider_avatar_usecase.dart';

class ProviderProfileController extends ChangeNotifier {
  final GetProviderMeUseCase getMe;
  final GetProviderProfileUseCase getProfile;
  final GetProviderTotalEarningsUseCase getTotalEarnings;
  final UpdateProviderProfileUseCase updateProfile;
  final UpdateProviderMeUseCase updateMe;
  final UploadProviderAvatarUseCase uploadAvatar;

  ProviderProfileController({
    required this.getMe,
    required this.getProfile,
    required this.getTotalEarnings,
    required this.updateProfile,
    required this.updateMe,
    required this.uploadAvatar,
  });

  bool loading = false;
  String? error;

  ProviderMeEntity? me;
  ProviderProfileEntity? profile;

  num totalEarnings = 0;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      me = await getMe();
      profile = await getProfile();
      totalEarnings = await getTotalEarnings();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshEarnings() async {
    try {
      totalEarnings = await getTotalEarnings();
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> saveEditProfile({
    required String firstName,
    required String lastName,
    required num startingPrice,
  }) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      me = await updateMe(firstName: firstName, lastName: lastName);

      final prof = (me?.profession ?? '').trim();
      if (prof.isEmpty) throw Exception("Profession not found");

      profile = await updateProfile(
        profession: prof,
        startingPrice: startingPrice,
      );

      totalEarnings = await getTotalEarnings();
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