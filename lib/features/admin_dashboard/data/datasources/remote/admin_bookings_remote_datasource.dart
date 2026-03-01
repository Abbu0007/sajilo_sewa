import 'package:dio/dio.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/core/services/storage/user_session_service.dart';
import 'package:sajilo_sewa/features/admin_dashboard/data/models/admin_booking_api_model.dart';

class AdminBookingsRemoteDatasource {
  final Dio dio;
  AdminBookingsRemoteDatasource(this.dio);

  static const String _bookings = '/api/admin/bookings';
  static String _byId(String id) => '/api/admin/bookings/$id';
  static String _cancel(String id) => '/api/admin/bookings/$id/cancel';

  Options _authOptions() {
    final token = UserSessionService.instance.getToken();
    return Options(headers: {
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    });
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
    if (status == 401 || status == 403) return AuthFailure(message: msg);
    return ServerFailure(message: msg);
  }

  Future<AdminBookingListResponse> list({
    required int page,
    required int limit,
    String status = 'all',
    String q = '',
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final res = await dio.get(
        _bookings,
        options: _authOptions(),
        queryParameters: {
          'page': page,
          'limit': limit,
          'status': status,
          if (q.trim().isNotEmpty) 'q': q.trim(),
          if (dateFrom != null) 'dateFrom': dateFrom.toIso8601String(),
          if (dateTo != null) 'dateTo': dateTo.toIso8601String(),
        },
      );

      final body = res.data;
      if (body is Map<String, dynamic>) {
        return AdminBookingListResponse.fromJson(body);
      }
      return AdminBookingListResponse(items: const [], page: page, limit: limit, total: 0, totalPages: 1);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ServerFailure(message: 'Failed to fetch bookings: $e');
    }
  }

  Future<AdminBookingApiModel> getById(String id) async {
    try {
      final res = await dio.get(_byId(id), options: _authOptions());
      final body = res.data;

      final bookingJson = (body is Map<String, dynamic> && body['booking'] is Map<String, dynamic>)
          ? (body['booking'] as Map<String, dynamic>)
          : (body is Map<String, dynamic> ? body : <String, dynamic>{});

      return AdminBookingApiModel.fromJson(bookingJson);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ServerFailure(message: 'Failed to fetch booking: $e');
    }
  }

  Future<AdminBookingApiModel> cancel({
    required String id,
    required String reason,
  }) async {
    try {
      final res = await dio.patch(
        _cancel(id),
        options: _authOptions(),
        data: {'reason': reason},
      );

      final body = res.data;
      final bookingJson = (body is Map<String, dynamic> && body['booking'] is Map<String, dynamic>)
          ? (body['booking'] as Map<String, dynamic>)
          : <String, dynamic>{};

      return AdminBookingApiModel.fromJson(bookingJson);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ServerFailure(message: 'Failed to cancel booking: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await dio.delete(_byId(id), options: _authOptions());
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ServerFailure(message: 'Failed to delete booking: $e');
    }
  }
}