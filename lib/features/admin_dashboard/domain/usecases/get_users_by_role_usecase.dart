import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_user_entity.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/repositories/i_admin_repository.dart';

class GetUsersByRoleUseCase {
  final IAdminRepository repository;

  GetUsersByRoleUseCase(this.repository);

  Future<Either<Failure, List<AdminUserEntity>>> call({
    required String role, // 'client' | 'provider'
  }) {
    return repository.getUsersByRole(role: role);
  }
}
