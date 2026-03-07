import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/dashboard/data/datasources/local/dashboard_local_datasource.dart';
import 'package:sajilo_sewa/features/dashboard/data/datasources/remote/profile_remote_datasource.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/profile_hive_model.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/profile_stats_api_model.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/profile_stats_hive_model.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/profile_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/repositories/i_profile_repository.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/providers/profile_providers.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final ds = ref.read(profileRemoteDataSourceProvider);
  final local = DashboardLocalDataSourceImpl();

  return ProfileRepository(
    profileRemoteDataSource: ds,
    localDataSource: local,
  );
});

class ProfileRepository implements IProfileRepository {
  final IProfileRemoteDataSource _profileRemoteDataSource;
  final DashboardLocalDataSource _localDataSource;

  ProfileRepository({
    required IProfileRemoteDataSource profileRemoteDataSource,
    required DashboardLocalDataSource localDataSource,
  })  : _profileRemoteDataSource = profileRemoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, ProfileEntity>> getMe() async {
    try {
      final model = await _profileRemoteDataSource.getMe();

      await _localDataSource.cacheProfile(
        ProfileHiveModel(
          id: model.id,
          firstName: model.firstName,
          lastName: model.lastName,
          email: model.email,
          phone: model.phone,
          role: model.role,
          profession: model.profession,
          avatarUrl: model.avatarUrl,
        ),
      );

      return right(model.toEntity());
    } catch (e) {
      try {
        final cached = await _localDataSource.getCachedProfile();

        if (cached != null) {
          return right(
            ProfileEntity(
              id: cached.id,
              firstName: cached.firstName,
              lastName: cached.lastName,
              email: cached.email,
              phone: cached.phone,
              role: cached.role,
              profession: cached.profession,
              avatarUrl: cached.avatarUrl,
            ),
          );
        }
      } catch (_) {}

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

      await _localDataSource.cacheProfile(
        ProfileHiveModel(
          id: model.id,
          firstName: model.firstName,
          lastName: model.lastName,
          email: model.email,
          phone: model.phone,
          role: model.role,
          profession: model.profession,
          avatarUrl: model.avatarUrl,
        ),
      );

      return right(model.toEntity());
    } catch (e) {
      if (e is Failure) return left(e);
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> uploadAvatar({
    required File file,
  }) async {
    try {
      final model = await _profileRemoteDataSource.uploadAvatar(file: file);

      await _localDataSource.cacheProfile(
        ProfileHiveModel(
          id: model.id,
          firstName: model.firstName,
          lastName: model.lastName,
          email: model.email,
          phone: model.phone,
          role: model.role,
          profession: model.profession,
          avatarUrl: model.avatarUrl,
        ),
      );

      return right(model.toEntity());
    } catch (e) {
      if (e is Failure) return left(e);
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileStatsApiModel>> getClientProfileStats() async {
    try {
      final stats = await _profileRemoteDataSource.getClientProfileStats();

      await _localDataSource.cacheProfileStats(
        ProfileStatsHiveModel(
          ratingAvg: stats.ratingAvg,
          ratingCount: stats.ratingCount,
          completedBookings: stats.completedBookings,
        ),
      );

      return right(stats);
    } catch (e) {
      try {
        final cached = await _localDataSource.getCachedProfileStats();

        if (cached != null) {
          return right(
            ProfileStatsApiModel(
              ratingAvg: cached.ratingAvg,
              ratingCount: cached.ratingCount,
              completedBookings: cached.completedBookings,
            ),
          );
        }
      } catch (_) {}

      if (e is Failure) return left(e);
      return left(ServerFailure(message: e.toString()));
    }
  }
}