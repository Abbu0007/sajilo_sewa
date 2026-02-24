import 'package:dio/dio.dart';
import 'package:sajilo_sewa/core/api/api_client.dart';
import 'package:sajilo_sewa/core/api/api_endpoints.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/notification_api_model.dart';
import '../../models/service_api_model.dart';
import '../../models/provider_api_model.dart';
import '../../models/booking_api_model.dart';

class DashboardRemoteDataSource {
  final Dio _dio;

  DashboardRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  Future<List<ServiceApiModel>> getServices() async {
    final res = await _dio.get(ApiEndpoints.services);
    final items = (res.data?['items'] as List? ?? []).cast<dynamic>();
    return items.map((e) => ServiceApiModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<List<ProviderApiModel>> getTopRatedProviders({int limit = 8}) async {
    final res = await _dio.get(ApiEndpoints.topRatedProviders(limit: limit));
    final items = (res.data?['items'] as List? ?? []).cast<dynamic>();
    return items.map((e) => ProviderApiModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<List<ProviderApiModel>> getProvidersByService(String slug) async {
    final res = await _dio.get(ApiEndpoints.providersByService(slug));
    final items = (res.data?['items'] as List? ?? []).cast<dynamic>();
    return items.map((e) => ProviderApiModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<List<ProviderApiModel>> getFavourites() async {
    final res = await _dio.get(ApiEndpoints.favourites);
    final items = (res.data?['items'] as List? ?? []).cast<dynamic>();
    return items.map((e) => ProviderApiModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }


  Future<bool> toggleFavourite(String providerId) async {
    final res = await _dio.post(ApiEndpoints.favouriteToggle(providerId), data: {});
    final isFav = res.data?['isFavourite'];
    return isFav == true;
  }

  Future<List<BookingApiModel>> getMyBookings({String status = "all"}) async {
    final res = await _dio.get(ApiEndpoints.myBookings(status: status));
    final items = (res.data?['items'] as List? ?? []).cast<dynamic>();
    return items.map((e) => BookingApiModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<List<NotificationApiModel>> getNotifications() async {
  final res = await _dio.get(ApiEndpoints.notifications);
  final items = (res.data?['items'] as List? ?? []).cast<dynamic>();
  return items.map((e) => NotificationApiModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> markNotificationRead(String id) async {
  await _dio.patch(ApiEndpoints.notificationRead(id), data: {});
  }

  Future<void> createRating({
  required String bookingId,
  required int stars,
  String? comment,}) async {
  final payload = {
    "bookingId": bookingId,
    "stars": stars,
    if (comment != null && comment.trim().isNotEmpty) "comment": comment.trim(),
  };

  await _dio.post(ApiEndpoints.ratings, data: payload);
  }

  Future<BookingApiModel> createBooking({
    required String providerId,
    required String serviceId,
    required String scheduledAt,
    String? addressText,
    String? note,
  }) async {
    final payload = {
      "providerId": providerId,
      "serviceId": serviceId,
      "scheduledAt": scheduledAt,
      if (addressText != null && addressText.trim().isNotEmpty) "addressText": addressText.trim(),
      if (note != null && note.trim().isNotEmpty) "note": note.trim(),
    };

    final res = await _dio.post(ApiEndpoints.createBooking, data: payload);
    final bookingJson = res.data?['booking'];
    if (bookingJson is! Map) {
      throw Exception("Invalid booking response");
    }
    return BookingApiModel.fromJson(Map<String, dynamic>.from(bookingJson));
  }
}