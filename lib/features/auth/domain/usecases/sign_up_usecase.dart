import 'package:either_dart/either.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../../data/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, void>> call(UserEntity user) {
    return repository.signUp(user);
  }
}
