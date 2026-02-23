import 'package:dio/dio.dart';
import 'package:sajilo_sewa/core/api/api_endpoints.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/auth/data/models/auth_api_model.dart';

class AuthRemoteDatasource {
  final Dio dio;
  AuthRemoteDatasource(this.dio);

  Map<String, String> _splitName(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) return {'firstName': '', 'lastName': ''};
    if (parts.length == 1) return {'firstName': parts[0], 'lastName': ''};

    return {
      'firstName': parts.first,
      'lastName': parts.sublist(1).join(' '),
    };
  }

  Future<AuthResponseModel> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? profession,
    String? serviceSlug,
  }) async {
    try {
      final name = _splitName(fullName);

      final Map<String, dynamic> data = {
        'firstName': name['firstName'],
        'lastName': name['lastName'],
        'email': email.trim(),
        'phone': phone.trim(),
        'role': role,
        'password': password,
      };

      
      if (role == "provider") {
        final p = (profession ?? '').trim();
        final s = (serviceSlug ?? '').trim();

        if (p.isEmpty || s.isEmpty) {
          throw ValidationFailure(
            message: "Profession and service are required for service providers",
          );
        }

        data['profession'] = p;
        data['serviceSlug'] = s;
      }

      final res = await dio.post(ApiEndpoints.register, data: data);
      return AuthResponseModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: 'Register failed: $e');
    }
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await dio.post(
        ApiEndpoints.login,
        data: {'email': email.trim(), 'password': password},
      );
      return AuthResponseModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ServerFailure(message: 'Login failed: $e');
    }
  }

  Failure _mapDioError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    String msg = 'Network error';
    if (data is Map<String, dynamic>) {
      msg = (data['message'] ?? data['error'] ?? msg).toString();
    }

    if (status == 400) return ValidationFailure(message: msg);
    if (status == 401) return AuthFailure(message: msg);
    if (status == 403) return AuthFailure(message: msg);
    if (status == 404) return ServerFailure(message: msg);

    return ServerFailure(message: msg);
  }
}
