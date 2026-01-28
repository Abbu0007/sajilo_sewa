import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/profile/domain/entities/profile_entity.dart';
import 'package:sajilo_sewa/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final IProfileRepository _repo;
  GetProfileUseCase(this._repo);

  Future<Either<Failure, ProfileEntity>> call() => _repo.getMe();
}
