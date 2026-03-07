import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/auth/domain/repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final IAuthRepository repository;

  VerifyEmailUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String email,
    required String otp,
  }) {
    return repository.verifyEmail(
      email: email,
      otp: otp,
    );
  }
}