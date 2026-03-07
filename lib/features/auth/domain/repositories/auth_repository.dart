import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, Unit>> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? profession,
    String? serviceSlug,
  });

  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> verifyEmail({
    required String email,
    required String otp,
  });

  Future<Either<Failure, Unit>> resendVerification({
    required String email,
  });

  Future<Either<Failure, Unit>> forgotPassword({
    required String email,
  });

  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<Either<Failure, Unit>> logout();
}