import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/auth/domain/repositories/auth_repository.dart';

class ResendVerificationUseCase {
  final IAuthRepository repository;

  ResendVerificationUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String email,
  }) {
    return repository.resendVerification(
      email: email,
    );
  }
}