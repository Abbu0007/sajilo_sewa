import 'package:either_dart/either.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../../data/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password) {
    return repository.login(email, password);
  }
}
