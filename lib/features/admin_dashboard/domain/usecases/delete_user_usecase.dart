import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/repositories/i_admin_repository.dart';

class DeleteUserUseCase {
  final IAdminRepository repository;

  DeleteUserUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String userId,
  }) {
    return repository.deleteUser(userId: userId);
  }
}
