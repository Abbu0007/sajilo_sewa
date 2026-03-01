import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/profile_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/repositories/i_profile_repository.dart';

class UpdateProfileUseCase {
  final IProfileRepository _repo;
  UpdateProfileUseCase(this._repo);

  Future<Either<Failure, ProfileEntity>> call({
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
  }) {
    return _repo.updateMe(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
    );
  }
}
