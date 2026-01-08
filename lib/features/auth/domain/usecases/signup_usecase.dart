import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? profession,
  }) {
    return repository.signUp(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
      profession: profession,
    );
  }
}
