import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final IAuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
