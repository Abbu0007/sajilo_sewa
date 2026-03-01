import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_service_entity.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/repositories/i_admin_repository.dart';

class GetServicesUseCase {
  final IAdminRepository repo;
  GetServicesUseCase(this.repo);

  Future<Either<Failure, List<AdminServiceEntity>>> call() {
    return repo.getServices();
  }
}