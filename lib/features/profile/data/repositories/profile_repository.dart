import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:sajilo_sewa/features/profile/domain/entities/profile_entity.dart';
import 'package:sajilo_sewa/features/profile/domain/repositories/profile_repository.dart';
import 'package:sajilo_sewa/features/profile/presentation/providers/profile_providers.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final ds = ref.read(profileRemoteDataSourceProvider);
  return ProfileRepository(profileRemoteDataSource: ds);
});

class ProfileRepository implements IProfileRepository {
  final IProfileRemoteDataSource _profileRemoteDataSource;

  ProfileRepository({required IProfileRemoteDataSource profileRemoteDataSource})
      : _profileRemoteDataSource = profileRemoteDataSource;

  @override
  Future<Either<Failure, ProfileEntity>> getMe() async {
    try {
      final model = await _profileRemoteDataSource.getMe();
      return right(model.toEntity());
    } catch (e) {
      if (e is Failure) return left(e);
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateMe({
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
  }) async {
    try {
      final model = await _profileRemoteDataSource.updateMe(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
      );
      return right(model.toEntity());
    } catch (e) {
      if (e is Failure) return left(e);
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> uploadAvatar({required File file}) async {
    try {
      final model = await _profileRemoteDataSource.uploadAvatar(file: file);
      return right(model.toEntity());
    } catch (e) {
      if (e is Failure) return left(e);
      return left(ServerFailure(message: e.toString()));
    }
  }
}
