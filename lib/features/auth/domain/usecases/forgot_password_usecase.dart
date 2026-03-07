import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final IAuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String email,
  }) {
    return repository.forgotPassword(
      email: email,
    );
  }
}