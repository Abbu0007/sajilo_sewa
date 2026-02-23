import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/core/api/api_client.dart';
import 'package:sajilo_sewa/features/dashboard/data/datasources/remote/profile_remote_datasource.dart';
import 'package:sajilo_sewa/features/dashboard/data/repositories/profile_repository.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_profile_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/update_profile_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/upload_avatar_usecase.dart';

final profileRemoteDataSourceProvider = Provider<IProfileRemoteDataSource>((ref) {
  final dio = ApiClient.instance.dio; 
  return ProfileRemoteDataSource(dio: dio);
});

final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  final repo = ref.read(profileRepositoryProvider);
  return GetProfileUseCase(repo);
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  final repo = ref.read(profileRepositoryProvider);
  return UpdateProfileUseCase(repo);
});

final uploadAvatarUseCaseProvider = Provider<UploadAvatarUseCase>((ref) {
  final repo = ref.read(profileRepositoryProvider);
  return UploadAvatarUseCase(repo);
});
