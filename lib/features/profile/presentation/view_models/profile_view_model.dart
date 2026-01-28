import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sajilo_sewa/features/profile/presentation/providers/profile_providers.dart';
import 'package:sajilo_sewa/features/profile/presentation/view_models/profile_state.dart';

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>((ref) {
  return ProfileViewModel(ref);
});

class ProfileViewModel extends StateNotifier<ProfileState> {
  final Ref _ref;

  ProfileViewModel(this._ref) : super(ProfileState.initial());

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    final useCase = _ref.read(getProfileUseCaseProvider);
    final res = await useCase();

    res.fold(
      (f) => state = state.copyWith(isLoading: false, error: f.message),
      (profile) => state = state.copyWith(isLoading: false, profile: profile, error: null),
    );
  }

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
  }) async {
    state = state.copyWith(isSaving: true, error: null);

    final useCase = _ref.read(updateProfileUseCaseProvider);
    final res = await useCase(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
    );

    return res.fold(
      (f) {
        state = state.copyWith(isSaving: false, error: f.message);
        return false;
      },
      (profile) {
        state = state.copyWith(isSaving: false, profile: profile, error: null);
        return true;
      },
    );
  }

  Future<bool> uploadAvatar(File file) async {
    state = state.copyWith(isSaving: true, error: null);

    final useCase = _ref.read(uploadAvatarUseCaseProvider);
    final res = await useCase(file: file);

    return res.fold(
      (f) {
        state = state.copyWith(isSaving: false, error: f.message);
        return false;
      },
      (profile) {
        state = state.copyWith(isSaving: false, profile: profile, error: null);
        return true;
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
