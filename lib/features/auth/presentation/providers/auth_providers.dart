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
import 'package:sajilo_sewa/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:sajilo_sewa/features/auth/domain/usecases/login_usecase.dart';
import 'package:sajilo_sewa/features/auth/domain/usecases/resend_verification_usecase.dart';
import 'package:sajilo_sewa/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:sajilo_sewa/features/auth/domain/usecases/signup_usecase.dart';
import 'package:sajilo_sewa/features/auth/domain/usecases/verify_email_usecase.dart';

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

/// Repository
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

final verifyEmailUseCaseProvider = Provider<VerifyEmailUseCase>(
  (ref) => VerifyEmailUseCase(ref.read(iAuthRepositoryProvider)),
);

final resendVerificationUseCaseProvider = Provider<ResendVerificationUseCase>(
  (ref) => ResendVerificationUseCase(ref.read(iAuthRepositoryProvider)),
);

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>(
  (ref) => ForgotPasswordUseCase(ref.read(iAuthRepositoryProvider)),
);

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>(
  (ref) => ResetPasswordUseCase(ref.read(iAuthRepositoryProvider)),
);

/// Controller
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<String?>>(
      (ref) => AuthController(
        ref.read(signUpUseCaseProvider),
        ref.read(loginUseCaseProvider),
        ref.read(verifyEmailUseCaseProvider),
        ref.read(resendVerificationUseCaseProvider),
        ref.read(forgotPasswordUseCaseProvider),
        ref.read(resetPasswordUseCaseProvider),
      ),
    );

class AuthController extends StateNotifier<AsyncValue<String?>> {
  final SignUpUseCase signUpUseCase;
  final LoginUseCase loginUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final ResendVerificationUseCase resendVerificationUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthController(
    this.signUpUseCase,
    this.loginUseCase,
    this.verifyEmailUseCase,
    this.resendVerificationUseCase,
    this.forgotPasswordUseCase,
    this.resetPasswordUseCase,
  ) : super(const AsyncValue.data(null));

  Future<void> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? profession,
    String? serviceSlug,
  }) async {
    state = const AsyncValue.loading();

    final result = await signUpUseCase(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      role: role,
      profession: profession,
      serviceSlug: serviceSlug,
    );

    state = result.fold(
      (failure) => AsyncValue.error(
        failure.message ?? 'Signup failed',
        StackTrace.current,
      ),
      (_) => const AsyncValue.data('success'),
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
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

  Future<void> verifyEmail({
    required String email,
    required String otp,
  }) async {
    state = const AsyncValue.loading();

    final result = await verifyEmailUseCase(
      email: email,
      otp: otp,
    );

    state = result.fold(
      (failure) => AsyncValue.error(
        failure.message ?? 'Email verification failed',
        StackTrace.current,
      ),
      (_) => const AsyncValue.data('verified'),
    );
  }

  Future<void> resendVerification({
    required String email,
  }) async {
    state = const AsyncValue.loading();

    final result = await resendVerificationUseCase(
      email: email,
    );

    state = result.fold(
      (failure) => AsyncValue.error(
        failure.message ?? 'Resend verification failed',
        StackTrace.current,
      ),
      (_) => const AsyncValue.data('resent'),
    );
  }

  Future<void> forgotPassword({
    required String email,
  }) async {
    state = const AsyncValue.loading();

    final result = await forgotPasswordUseCase(
      email: email,
    );

    state = result.fold(
      (failure) => AsyncValue.error(
        failure.message ?? 'Forgot password request failed',
        StackTrace.current,
      ),
      (_) => const AsyncValue.data('otp_sent'),
    );
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    state = const AsyncValue.loading();

    final result = await resetPasswordUseCase(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );

    state = result.fold(
      (failure) => AsyncValue.error(
        failure.message ?? 'Password reset failed',
        StackTrace.current,
      ),
      (_) => const AsyncValue.data('password_reset'),
    );
  }
}