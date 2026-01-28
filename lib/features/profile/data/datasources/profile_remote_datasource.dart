import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:sajilo_sewa/core/api/api_endpoints.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/profile/data/models/profile_api_model.dart';

abstract class IProfileRemoteDataSource {
  Future<ProfileApiModel> getMe();
  Future<ProfileApiModel> updateMe({
    required String firstName,
    required String lastName,
    required String phone,
    String? email, // optional if your backend allows
  });

  Future<ProfileApiModel> uploadAvatar({
    required File file,
  });
}

class ProfileRemoteDataSource implements IProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<ProfileApiModel> getMe() async {
    try {
      final res = await _dio.get(ApiEndpoints.me);

      // Your backend returns { message, user: {...} }
      final data = res.data as Map<String, dynamic>;
      final userJson = (data['user'] ?? data) as Map<String, dynamic>;

      return ProfileApiModel.fromJson(userJson);
    } on DioException catch (e) {
      throw ServerFailure(message: _dioMessage(e));
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<ProfileApiModel> updateMe({
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
  }) async {
    try {
      final body = <String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
      };

      if (email != null) body['email'] = email;

      final res = await _dio.patch(ApiEndpoints.updateMe, data: body);

      final data = res.data as Map<String, dynamic>;
      final userJson = (data['user'] ?? data) as Map<String, dynamic>;

      return ProfileApiModel.fromJson(userJson);
    } on DioException catch (e) {
      throw ServerFailure(message: _dioMessage(e));
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<ProfileApiModel> uploadAvatar({required File file}) async {
    try {
      final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      final parts = mimeType.split('/');
      final mediaType = MediaType(parts.first, parts.length > 1 ? parts[1] : 'jpeg');

      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          file.path,
          contentType: mediaType,
          filename: file.path.split('/').last,
        ),
      });

      final res = await _dio.post(
        ApiEndpoints.uploadAvatar,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      final data = res.data as Map<String, dynamic>;
      final userJson = (data['user'] ?? data) as Map<String, dynamic>;

      return ProfileApiModel.fromJson(userJson);
    } on DioException catch (e) {
      throw ServerFailure(message: _dioMessage(e));
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  String _dioMessage(DioException e) {
    final res = e.response?.data;
    if (res is Map<String, dynamic>) {
      final msg = res['message'] ?? res['error'];
      if (msg != null) return msg.toString();
    }
    return e.message ?? 'Server error';
  }
}
