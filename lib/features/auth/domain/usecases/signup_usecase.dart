import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final IAuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? profession,
  }) {
    return repository.signUp(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      role: role,
      profession: profession,
    );
  }
}
