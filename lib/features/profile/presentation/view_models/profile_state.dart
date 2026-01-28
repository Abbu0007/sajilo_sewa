import 'package:sajilo_sewa/features/profile/domain/entities/profile_entity.dart';

class ProfileState {
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final ProfileEntity? profile;

  const ProfileState({
    required this.isLoading,
    required this.isSaving,
    this.error,
    this.profile,
  });

  factory ProfileState.initial() => const ProfileState(
        isLoading: false,
        isSaving: false,
        error: null,
        profile: null,
      );

  ProfileState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? error,
    ProfileEntity? profile,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      profile: profile ?? this.profile,
    );
  }
}
