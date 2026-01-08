import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> signUp({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? profession,
  });

  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();
}
