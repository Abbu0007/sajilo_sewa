import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/dashboard/data/datasources/remote/profile_remote_datasource.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/profile_stats_api_model.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/profile_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/repositories/i_profile_repository.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/providers/profile_providers.dart';

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

  // ✅ ADD
  @override
  Future<Either<Failure, ProfileStatsApiModel>> getClientProfileStats() async {
    try {
      final stats = await _profileRemoteDataSource.getClientProfileStats();
      return right(stats);
    } catch (e) {
      if (e is Failure) return left(e);
      return left(ServerFailure(message: e.toString()));
    }
  }
}