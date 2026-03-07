import 'package:flutter_riverpod/legacy.dart';
import '../../domain/usecases/get_provider_me_usecase.dart';
import '../../domain/usecases/get_provider_profile_usecase.dart';
import '../../domain/usecases/get_provider_total_earnings_usecase.dart';
import '../../domain/usecases/update_provider_me_usecase.dart';
import '../../domain/usecases/update_provider_profile_usecase.dart';
import '../../domain/usecases/upload__provider_avatar_usecase.dart';
import 'provider_profile_state.dart';

class ProviderProfileNotifier extends StateNotifier<ProviderProfileState> {
  final GetProviderMeUseCase getMe;
  final GetProviderProfileUseCase getProfile;
  final GetProviderTotalEarningsUseCase getTotalEarnings;
  final UpdateProviderProfileUseCase updateProfile;
  final UpdateProviderMeUseCase updateMe;
  final UploadProviderAvatarUseCase uploadAvatar;

  ProviderProfileNotifier({
    required this.getMe,
    required this.getProfile,
    required this.getTotalEarnings,
    required this.updateProfile,
    required this.updateMe,
    required this.uploadAvatar,
  }) : super(ProviderProfileState.initial());

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final me = await getMe();
      final profile = await getProfile();
      final totalEarnings = await getTotalEarnings();

      state = state.copyWith(
        loading: false,
        me: me,
        profile: profile,
        totalEarnings: totalEarnings,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> refreshEarnings() async {
    try {
      final totalEarnings = await getTotalEarnings();
      state = state.copyWith(
        totalEarnings: totalEarnings,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<bool> saveEditProfile({
    required String firstName,
    required String lastName,
    required num startingPrice,
  }) async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final updatedMe = await updateMe(
        firstName: firstName,
        lastName: lastName,
      );

      final prof = (updatedMe.profession ?? '').trim();
      if (prof.isEmpty) {
        throw Exception("Profession not found");
      }

      final updatedProfile = await updateProfile(
        profession: prof,
        startingPrice: startingPrice,
      );

      final totalEarnings = await getTotalEarnings();

      state = state.copyWith(
        loading: false,
        me: updatedMe,
        profile: updatedProfile,
        totalEarnings: totalEarnings,
        clearError: true,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> uploadMyAvatar(String filePath) async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final updatedMe = await uploadAvatar(filePath);

      state = state.copyWith(
        loading: false,
        me: updatedMe,
        clearError: true,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }
}