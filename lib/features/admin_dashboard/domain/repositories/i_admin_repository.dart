import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_user_entity.dart';

abstract class IAdminRepository {
  Future<Either<Failure, List<AdminUserEntity>>> getUsersByRole({
    required String role,
  });

  Future<Either<Failure, AdminUserEntity>> createUser({
    required String fullName,
    required String email,
    required String phone,
    required String role,
    String? profession,
    String? password,
    XFile? avatarFile,
  });

  Future<Either<Failure, AdminUserEntity>> updateUser({
    required String userId,
    required String fullName,
    required String phone,
    required String role,
    String? profession,
    XFile? avatarFile,
  });

  Future<Either<Failure, void>> deleteUser({
    required String userId,
  });
}
