import 'package:dartz/dartz.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/services/hive/hive_service.dart';
import '../../../../core/error/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final HiveService hive;

  AuthRepositoryImpl(this.hive);

  @override
  Future<Either<Failure, void>> signUp({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? profession,
  }) {
    return hive.signUp(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
      profession: profession,
    );
  }

  @override
  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  }) {
    return hive.login(email: email, password: password);
  }

  @override
  Future<Either<Failure, void>> logout() {
    return hive.logout();
  }
}
