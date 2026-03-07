import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final IAuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String email,
    required String otp,
    required String newPassword,
  }) {
    return repository.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
  }
}