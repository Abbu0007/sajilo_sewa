import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../../../core/services/hive/hive_service.dart';

final authRepositoryProvider = Provider<AuthRepositoryImpl>(
  (ref) => AuthRepositoryImpl(HiveService.instance),
);

final signUpUseCaseProvider = Provider<SignUpUseCase>(
  (ref) => SignUpUseCase(ref.read(authRepositoryProvider)),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.read(authRepositoryProvider)),
);

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<String?>>(
      (ref) => AuthController(
        ref.read(signUpUseCaseProvider),
        ref.read(loginUseCaseProvider),
      ),
    );

class AuthController extends StateNotifier<AsyncValue<String?>> {
  final SignUpUseCase signUpUseCase;
  final LoginUseCase loginUseCase;

  AuthController(this.signUpUseCase, this.loginUseCase)
    : super(const AsyncValue.data(null));

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? profession,
  }) async {
    state = const AsyncValue.loading();

    final result = await signUpUseCase(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
      profession: profession,
    );

    state = result.fold(
      (failure) => AsyncValue.error(
        failure.message ?? 'Signup failed',
        StackTrace.current,
      ),
      (_) => const AsyncValue.data('success'),
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();

    final result = await loginUseCase(email: email, password: password);

    state = result.fold(
      (failure) => AsyncValue.error(
        failure.message ?? 'Login failed',
        StackTrace.current,
      ),
      (role) => AsyncValue.data(role),
    );
  }
}
