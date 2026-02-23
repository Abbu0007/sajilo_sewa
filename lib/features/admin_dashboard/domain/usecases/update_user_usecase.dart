import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_user_entity.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/repositories/i_admin_repository.dart';

class UpdateUserUseCase {
  final IAdminRepository repository;

  UpdateUserUseCase(this.repository);

  Future<Either<Failure, AdminUserEntity>> call({
    required String userId,
    required String fullName,
    required String phone,
    required String role,
    String? profession,
    XFile? avatarFile,
  }) {
    return repository.updateUser(
      userId: userId,
      fullName: fullName,
      phone: phone,
      role: role,
      profession: profession,
      avatarFile: avatarFile,
    );
  }
}
