import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sajilo_sewa/core/api/api_client.dart';
import 'package:sajilo_sewa/core/services/connectivity/network_info.dart';
import 'package:sajilo_sewa/core/services/hive/hive_service.dart';
import 'package:sajilo_sewa/features/auth/data/datasources/auth_datasource.dart';
import 'package:sajilo_sewa/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:sajilo_sewa/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:sajilo_sewa/features/auth/data/repositories/auth_repository.dart';
import 'package:sajilo_sewa/features/auth/domain/repositories/auth_repository.dart';
import 'package:sajilo_sewa/features/auth/domain/usecases/login_usecase.dart';
import 'package:sajilo_sewa/features/auth/domain/usecases/signup_usecase.dart';

/// Core singletons
final hiveServiceProvider = Provider<HiveService>(
  (ref) => HiveService.instance,
);
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient.instance);
final networkInfoProvider = Provider<NetworkInfo>(
  (ref) => NetworkInfo.instance,
);

/// Datasources
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>(
  (ref) => AuthRemoteDatasource(ref.read(apiClientProvider).dio),
);

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>(
  (ref) => AuthLocalDatasource(ref.read(hiveServiceProvider)),
);

/// Controller datasource (controls remote/local)
final authDataSourceProvider = Provider<IAuthDataSource>((ref) {
  return AuthDataSource(
    networkInfo: ref.read(networkInfoProvider),
    remote: ref.read(authRemoteDatasourceProvider),
    local: ref.read(authLocalDatasourceProvider),
    hive: ref.read(hiveServiceProvider),
  );
});

/// Repository (sir style) — comes from data/repositories/auth_repository.dart
final iAuthRepositoryProvider = Provider<IAuthRepository>(
  (ref) => ref.read(authRepositoryProvider),
);

/// Usecases
final signUpUseCaseProvider = Provider<SignUpUseCase>(
  (ref) => SignUpUseCase(ref.read(iAuthRepositoryProvider)),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.read(iAuthRepositoryProvider)),
);

/// Controller
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
    required String phone,
    required String password,
    required String role,
    String? profession,
  }) async {
    state = const AsyncValue.loading();

    final result = await signUpUseCase(
      fullName: fullName,
      email: email,
      phone: phone,
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
