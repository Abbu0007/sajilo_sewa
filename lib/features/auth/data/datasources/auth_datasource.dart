import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/core/services/connectivity/network_info.dart';
import 'package:sajilo_sewa/core/services/hive/hive_service.dart';
import 'package:sajilo_sewa/core/services/storage/user_session_service.dart';
import 'package:sajilo_sewa/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:sajilo_sewa/features/auth/data/datasources/remote/auth_remote_datasource.dart';

abstract interface class IAuthDataSource {
  Future<void> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? profession,
    String? serviceSlug,
  });

  Future<String> login({
    required String email,
    required String password,
  });

  Future<void> verifyEmail({
    required String email,
    required String otp,
  });

  Future<void> resendVerification({
    required String email,
  });

  Future<void> forgotPassword({
    required String email,
  });

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<void> logout();
}

class AuthDataSource implements IAuthDataSource {
  final NetworkInfo networkInfo;
  final AuthRemoteDatasource remote;
  final AuthLocalDatasource local;
  final HiveService hive;

  AuthDataSource({
    required this.networkInfo,
    required this.remote,
    required this.local,
    required this.hive,
  });

  @override
  Future<void> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? profession,
    String? serviceSlug,
  }) async {
    try {
      final online = await networkInfo.isConnected;

      if (online) {
        await remote.register(
          fullName: fullName,
          email: email,
          phone: phone,
          password: password,
          role: role,
          profession: profession,
          serviceSlug: serviceSlug,
        );
        return;
      }

      await local.signUp(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        role: role,
        profession: profession,
        serviceSlug: serviceSlug,
      );
    } catch (e) {
      if (e is Failure) throw e;
      throw ServerFailure(message: 'Signup failed: $e');
    }
  }

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final online = await networkInfo.isConnected;

      if (online) {
        final data = await remote.login(email: email, password: password);

        await UserSessionService.instance.saveSession(
          userKey: data.user.email.trim().toLowerCase(),
          role: data.user.role,
          token: data.token,
        );

        await hive.cacheUserFromApi(
          id: data.user.id,
          fullName: data.user.toEntity().fullName,
          email: data.user.email,
          phone: data.user.phone,
          role: data.user.role,
          profession: data.user.profession,
          token: data.token,
        );

        return data.user.role;
      }

      return await local.login(email: email, password: password);
    } catch (e) {
      if (e is Failure) throw e;
      throw ServerFailure(message: 'Login failed: $e');
    }
  }

  @override
  Future<void> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      final online = await networkInfo.isConnected;
      if (!online) {
        throw ServerFailure(message: 'No internet connection');
      }

      await remote.verifyEmail(
        email: email,
        otp: otp,
      );
    } catch (e) {
      if (e is Failure) throw e;
      throw ServerFailure(message: 'Verify email failed: $e');
    }
  }

  @override
  Future<void> resendVerification({
    required String email,
  }) async {
    try {
      final online = await networkInfo.isConnected;
      if (!online) {
        throw ServerFailure(message: 'No internet connection');
      }

      await remote.resendVerification(
        email: email,
      );
    } catch (e) {
      if (e is Failure) throw e;
      throw ServerFailure(message: 'Resend verification failed: $e');
    }
  }

  @override
  Future<void> forgotPassword({
    required String email,
  }) async {
    try {
      final online = await networkInfo.isConnected;
      if (!online) {
        throw ServerFailure(message: 'No internet connection');
      }

      await remote.forgotPassword(
        email: email,
      );
    } catch (e) {
      if (e is Failure) throw e;
      throw ServerFailure(message: 'Forgot password failed: $e');
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final online = await networkInfo.isConnected;
      if (!online) {
        throw ServerFailure(message: 'No internet connection');
      }

      await remote.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
    } catch (e) {
      if (e is Failure) throw e;
      throw ServerFailure(message: 'Reset password failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await UserSessionService.instance.clearSession();
      await local.logout();
    } catch (e) {
      if (e is Failure) throw e;
      throw ServerFailure(message: 'Logout failed: $e');
    }
  }
}