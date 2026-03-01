import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_user_entity.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/repositories/i_admin_repository.dart';

class CreateUserUseCase {
  final IAdminRepository repository;
  CreateUserUseCase(this.repository);

  Future<Either<Failure, AdminUserEntity>> call({
    required String fullName,
    required String email,
    required String phone,
    required String role,
    required String password,
    String? profession,
    String? serviceSlug, 
    XFile? avatarFile,
  }) {
    return repository.createUser(
      fullName: fullName,
      email: email,
      phone: phone,
      role: role,
      password: password,
      profession: profession,
      serviceSlug: serviceSlug, 
      avatarFile: avatarFile,
    );
  }
}