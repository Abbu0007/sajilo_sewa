import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/core/services/storage/user_session_service.dart';
import 'package:sajilo_sewa/features/admin_dashboard/data/models/admin_service_api_model.dart';
import 'package:sajilo_sewa/features/admin_dashboard/data/models/admin_user_api_model.dart';

class AdminRemoteDatasource {
  final Dio dio;
  AdminRemoteDatasource(this.dio);

  static const String _usersEndpoint = '/api/admin/users';
  static const String _createUserEndpoint = '/api/admin/users';
  static String _userByIdEndpoint(String id) => '/api/admin/users/$id';
  static String _uploadAvatarEndpoint(String id) => '/api/admin/users/$id/avatar';
  static String _deleteAvatarEndpoint(String id) => '/api/admin/users/$id/avatar';
  static const String _servicesEndpoint = '/api/admin/services';

  Options _authOptions() {
    final token = UserSessionService.instance.getToken();
    return Options(
      headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
  }

  Future<List<AdminUserApiModel>> getUsersByRole({required String role}) async {
    try {
      final res = await dio.get(
        _usersEndpoint,
        queryParameters: {'role': role},
        options: _authOptions(),
      );

      final data = res.data;

      final List list = (data is Map<String, dynamic>)
          ? (data['users'] as List? ?? const [])
          : (data as List? ?? const []);

      return list
          .map((e) => AdminUserApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ServerFailure(message: 'Failed to fetch users: $e');
    }
  }
  Future<AdminUserApiModel> createUser({
  required String fullName,
  required String email,
  required String phone,
  required String role,
  String? profession,
  String? serviceSlug,
  String? password,
  XFile? avatarFile,
}) async {
  try {
    final parts = _splitName(fullName);
    final normalizedRole = role.trim().toLowerCase();

    final form = FormData.fromMap({
      'firstName': parts['firstName'],
      'lastName': parts['lastName'],
      'email': email.trim(),
      'phone': phone.trim(),
      'role': role.trim(),
      'password': (password ?? '').trim(),
      'profession': role.trim() == 'provider' ? (profession ?? '').trim() : '',
      'serviceSlug': normalizedRole == 'provider' ? (serviceSlug ?? '').trim() : '', 
      if (avatarFile != null)
        'avatar': await MultipartFile.fromFile(
          avatarFile.path,
          filename: avatarFile.name,
        ),
    });

    final res = await dio.post(
      _createUserEndpoint,
      data: form,
      options: _authOptions().copyWith(contentType: 'multipart/form-data'),
    );

    final body = res.data;
    final Map<String, dynamic> userJson =
        (body is Map<String, dynamic> && body['user'] is Map<String, dynamic>)
            ? body['user']
            : (body is Map<String, dynamic> ? body : <String, dynamic>{});

    return AdminUserApiModel.fromJson(userJson);
  } on DioException catch (e) {
    throw _mapDioError(e);
  } catch (e) {
    throw ServerFailure(message: 'Failed to create user: $e');
  }
}

Future<AdminUserApiModel> updateUser({
  required String userId,
  required String fullName,
  required String phone,
  String? role,
  String? profession,
  XFile? avatarFile,
}) async {
  try {
    final parts = _splitName(fullName);

    final form = FormData.fromMap({
      'firstName': parts['firstName'],
      'lastName': parts['lastName'],
      'phone': phone.trim(),
      if (role != null) 'role': role,
      if (role == 'provider')
        'profession': (profession ?? '').trim()
      else
        'profession': '',
      if (avatarFile != null)
        'avatar': await MultipartFile.fromFile(
          avatarFile.path,
          filename: avatarFile.name,
        ),
    });

    final res = await dio.put(
      _userByIdEndpoint(userId),
      data: form,
      options: _authOptions().copyWith(
        contentType: 'multipart/form-data',
      ),
    );

    final body = res.data;

    final Map<String, dynamic> userJson =
        (body is Map<String, dynamic> && body['user'] is Map<String, dynamic>)
            ? body['user']
            : <String, dynamic>{};

    return AdminUserApiModel.fromJson(userJson);
  } on DioException catch (e) {
    throw _mapDioError(e);
  } catch (e) {
    throw ServerFailure(message: 'Failed to update user: $e');
  }
}

  

  Future<AdminUserApiModel> uploadAvatar({
    required String userId,
    required XFile file,
  }) async {
    try {
      final form = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        ),
      });

      final res = await dio.post(
        _uploadAvatarEndpoint(userId),
        data: form,
        options: _authOptions().copyWith(contentType: 'multipart/form-data'),
      );

      final body = res.data;
      final Map<String, dynamic> userJson = (body is Map<String, dynamic> && body['user'] is Map<String, dynamic>)
          ? (body['user'] as Map<String, dynamic>)
          : <String, dynamic>{};

      return AdminUserApiModel.fromJson(userJson);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ServerFailure(message: 'Failed to upload avatar: $e');
    }
  }

  Future<AdminUserApiModel> deleteAvatar({required String userId}) async {
    try {
      final res = await dio.delete(
        _deleteAvatarEndpoint(userId),
        options: _authOptions(),
      );

      final body = res.data;
      final Map<String, dynamic> userJson = (body is Map<String, dynamic> && body['user'] is Map<String, dynamic>)
          ? (body['user'] as Map<String, dynamic>)
          : <String, dynamic>{};

      return AdminUserApiModel.fromJson(userJson);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ServerFailure(message: 'Failed to delete avatar: $e');
    }
  }

  Future<void> deleteUser({required String userId}) async {
    try {
      await dio.delete(
        _userByIdEndpoint(userId),
        options: _authOptions(),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ServerFailure(message: 'Failed to delete user: $e');
    }
  }

  Future<List<AdminServiceApiModel>> getServices() async {
  try {
    final res = await dio.get(
      _servicesEndpoint,
      options: _authOptions(),
    );

    final data = res.data;
    final List list = (data is Map<String, dynamic>)
        ? (data['items'] as List? ?? const [])
        : (data as List? ?? const []);

    return list
        .map((e) => AdminServiceApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  } on DioException catch (e) {
    throw _mapDioError(e);
  } catch (e) {
    throw ServerFailure(message: 'Failed to fetch services: $e');
  }
}


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

  Failure _mapDioError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    String msg = 'Network error';
    if (data is Map<String, dynamic>) {
      msg = (data['message'] ?? data['error'] ?? msg).toString();
    } else if (e.message != null) {
      msg = e.message!;
    }

    if (status == 400) return ValidationFailure(message: msg);
    if (status == 401) return AuthFailure(message: msg);
    if (status == 403) return AuthFailure(message: msg);

    return ServerFailure(message: msg);
  }




}
