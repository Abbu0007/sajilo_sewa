import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sajilo_sewa/features/provider_dashboard/data/datasources/local/provider_local_datasource.dart';
import '../../data/datasources/remote/provider_remote_datasource.dart';
import '../../data/repositories/provider_repository_impl.dart';
import '../../domain/repositories/i_provider_repository.dart';
import '../../domain/usecases/get_provider_me_usecase.dart';
import '../../domain/usecases/get_provider_profile_usecase.dart';
import '../../domain/usecases/get_provider_total_earnings_usecase.dart';
import '../../domain/usecases/update_provider_me_usecase.dart';
import '../../domain/usecases/update_provider_profile_usecase.dart';
import '../../domain/usecases/upload__provider_avatar_usecase.dart';
import 'provider_profile_notifier.dart';
import 'provider_profile_state.dart';

final providerRemoteDataSourceProvider = Provider<ProviderRemoteDataSource>((ref) {
  return ProviderRemoteDataSource();
});
final providerRepositoryProvider = Provider<IProviderRepository>((ref) {
  return ProviderRepositoryImpl(
    remote: ref.read(providerRemoteDataSourceProvider),
    local: ProviderLocalDataSourceImpl(),
  );
});

final getProviderMeUseCaseProvider = Provider<GetProviderMeUseCase>((ref) {
  return GetProviderMeUseCase(ref.read(providerRepositoryProvider));
});

final getProviderProfileUseCaseProvider =
    Provider<GetProviderProfileUseCase>((ref) {
  return GetProviderProfileUseCase(ref.read(providerRepositoryProvider));
});

final getProviderTotalEarningsUseCaseProvider =
    Provider<GetProviderTotalEarningsUseCase>((ref) {
  return GetProviderTotalEarningsUseCase(ref.read(providerRepositoryProvider));
});

final updateProviderProfileUseCaseProvider =
    Provider<UpdateProviderProfileUseCase>((ref) {
  return UpdateProviderProfileUseCase(ref.read(providerRepositoryProvider));
});

final updateProviderMeUseCaseProvider = Provider<UpdateProviderMeUseCase>((ref) {
  return UpdateProviderMeUseCase(ref.read(providerRepositoryProvider));
});

final uploadProviderAvatarUseCaseProvider =
    Provider<UploadProviderAvatarUseCase>((ref) {
  return UploadProviderAvatarUseCase(ref.read(providerRepositoryProvider));
});

final providerProfileProvider =
    StateNotifierProvider<ProviderProfileNotifier, ProviderProfileState>((ref) {
  return ProviderProfileNotifier(
    getMe: ref.read(getProviderMeUseCaseProvider),
    getProfile: ref.read(getProviderProfileUseCaseProvider),
    getTotalEarnings: ref.read(getProviderTotalEarningsUseCaseProvider),
    updateProfile: ref.read(updateProviderProfileUseCaseProvider),
    updateMe: ref.read(updateProviderMeUseCaseProvider),
    uploadAvatar: ref.read(uploadProviderAvatarUseCaseProvider),
  );
});