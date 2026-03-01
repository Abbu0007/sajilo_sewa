import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/admin_dashboard/data/datasources/remote/admin_remote_datasource.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_service_entity.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_user_entity.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/repositories/i_admin_repository.dart';

class AdminRepositoryImpl implements IAdminRepository {
  final AdminRemoteDatasource remote;

  AdminRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, List<AdminUserEntity>>> getUsersByRole({
    required String role,
  }) async {
    try {
      final users = await remote.getUsersByRole(role: role);
      return Right(users.map((e) => e.toEntity()).toList());
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminUserEntity>> createUser({
    required String fullName,
    required String email,
    required String phone,
    required String role,
    String? profession,
    String? serviceSlug,
    String? password,
    XFile? avatarFile,
  }) async {
    try {
      final user = await remote.createUser(
        fullName: fullName,
        email: email,
        phone: phone,
        role: role,
        profession: profession,
        serviceSlug: serviceSlug,
        password: password,
        avatarFile: avatarFile
      );
      return Right(user.toEntity());
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminUserEntity>> updateUser({
    required String userId,
    required String fullName,
    required String phone,
    required String role,
    String? profession,
    XFile? avatarFile,
  }) async {
    try {
      final user = await remote.updateUser(
        userId: userId,
        fullName: fullName,
        phone: phone,
        role: role,
        profession: profession,
        avatarFile: avatarFile,
      );
      return Right(user.toEntity());
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser({required String userId}) async {
    try {
      await remote.deleteUser(userId: userId);
      return const Right(null);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AdminServiceEntity>>> getServices() async {
  try {
    final items = await remote.getServices();
    return Right(items.map((e) => e.toEntity()).toList());
  } catch (e) {
    if (e is Failure) return Left(e);
    return Left(ServerFailure(message: e.toString()));
  }
  }
}
