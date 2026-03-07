import '../../domain/entities/provider_me_entity.dart';
import '../../domain/entities/provider_profile_entity.dart';

class ProviderProfileState {
  final bool loading;
  final String? error;
  final ProviderMeEntity? me;
  final ProviderProfileEntity? profile;
  final num totalEarnings;

  const ProviderProfileState({
    required this.loading,
    required this.error,
    required this.me,
    required this.profile,
    required this.totalEarnings,
  });

  factory ProviderProfileState.initial() {
    return const ProviderProfileState(
      loading: false,
      error: null,
      me: null,
      profile: null,
      totalEarnings: 0,
    );
  }

  ProviderProfileState copyWith({
    bool? loading,
    String? error,
    ProviderMeEntity? me,
    ProviderProfileEntity? profile,
    num? totalEarnings,
    bool clearError = false,
  }) {
    return ProviderProfileState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      me: me ?? this.me,
      profile: profile ?? this.profile,
      totalEarnings: totalEarnings ?? this.totalEarnings,
    );
  }
}