import 'package:flutter/material.dart';
import 'package:either_dart/either.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

class AuthViewModel extends ChangeNotifier {
  final SignUpUseCase signUpUseCase;
  final LoginUseCase loginUseCase;

  AuthViewModel({required this.signUpUseCase, required this.loginUseCase});

  Future<Either<Failure, void>> signUp(UserEntity user) {
    return signUpUseCase(user);
  }

  Future<Either<Failure, UserEntity>> login(String email, String password) {
    return loginUseCase(email, password);
  }
}
