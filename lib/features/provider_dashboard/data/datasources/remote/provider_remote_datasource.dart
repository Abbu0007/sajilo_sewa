import 'package:dio/dio.dart';
import 'package:sajilo_sewa/core/api/api_client.dart';
import 'package:sajilo_sewa/core/api/api_endpoints.dart';
import 'package:sajilo_sewa/features/provider_dashboard/data/models/provider_booking_api_model.dart';
import 'package:sajilo_sewa/features/provider_dashboard/data/models/provider_me_model.dart';
import 'package:sajilo_sewa/features/provider_dashboard/data/models/provider_notification_api_model.dart';
import '../../models/provider_profile_api_model.dart';

class ProviderRemoteDataSource {
  final Dio _dio;

  ProviderRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  // -------- ME (User) --------
  Future<ProviderMeApiModel> getMe() async {
    final res = await _dio.get(ApiEndpoints.me);
    final data = (res.data is Map) ? Map<String, dynamic>.from(res.data) : <String, dynamic>{};

    // backend might return {user: {...}} or directly user fields
    final userJson = data['user'] is Map ? Map<String, dynamic>.from(data['user']) : data;
    return ProviderMeApiModel.fromJson(userJson);
  }

  
  Future<ProviderProfileApiModel?> getMyProviderProfile() async {
    final res = await _dio.get(ApiEndpoints.providerMeProfile);
    final data = (res.data is Map) ? Map<String, dynamic>.from(res.data) : <String, dynamic>{};

    final profileJson = data['profile'];
    if (profileJson is! Map) return null;
    return ProviderProfileApiModel.fromJson(Map<String, dynamic>.from(profileJson));
  }

  Future<ProviderProfileApiModel> updateMyProviderProfile({
    required String profession,
    String? bio,
    num? startingPrice,
    List<String>? serviceAreas,
    String? availability, // available | busy | offline
  }) async {
    final payload = <String, dynamic>{
      "profession": profession,
      if (bio != null) "bio": bio,
      if (startingPrice != null) "startingPrice": startingPrice,
      if (serviceAreas != null) "serviceAreas": serviceAreas,
      if (availability != null) "availability": availability,
    };

    final res = await _dio.put(ApiEndpoints.providerMeProfile, data: payload);
    final data = (res.data is Map) ? Map<String, dynamic>.from(res.data) : <String, dynamic>{};

    final profileJson = data['profile'];
    if (profileJson is! Map) {
      throw Exception("Invalid provider profile response");
    }
    return ProviderProfileApiModel.fromJson(Map<String, dynamic>.from(profileJson));
  }

  // -------- Provider Bookings --------
  Future<List<ProviderBookingApiModel>> getProviderBookings({String status = "all"}) async {
    final res = await _dio.get(ApiEndpoints.providerBookingsMine(status: status));
    final items = (res.data?['items'] as List? ?? []).cast<dynamic>();

    return items
        .map((e) => ProviderBookingApiModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<ProviderBookingApiModel> acceptBooking(String bookingId) async {
    final res = await _dio.patch(ApiEndpoints.providerBookingAccept(bookingId), data: {});
    final bookingJson = res.data?['booking'];
    if (bookingJson is! Map) throw Exception("Invalid booking response");
    return ProviderBookingApiModel.fromJson(Map<String, dynamic>.from(bookingJson));
  }

  Future<ProviderBookingApiModel> rejectBooking(String bookingId, {String? reason}) async {
    final payload = <String, dynamic>{};
    if (reason != null && reason.trim().isNotEmpty) payload['reason'] = reason.trim();

    final res = await _dio.patch(ApiEndpoints.providerBookingReject(bookingId), data: payload);
    final bookingJson = res.data?['booking'];
    if (bookingJson is! Map) throw Exception("Invalid booking response");
    return ProviderBookingApiModel.fromJson(Map<String, dynamic>.from(bookingJson));
  }

  Future<ProviderBookingApiModel> updateBookingStatus(
    String bookingId, {
    required String status, // in_progress | completed | cancelled
    String? reason,
  }) async {
    final payload = <String, dynamic>{
      "status": status,
      if (reason != null && reason.trim().isNotEmpty) "reason": reason.trim(),
    };

    final res = await _dio.patch(ApiEndpoints.providerBookingUpdateStatus(bookingId), data: payload);
    final bookingJson = res.data?['booking'];
    if (bookingJson is! Map) throw Exception("Invalid booking response");
    return ProviderBookingApiModel.fromJson(Map<String, dynamic>.from(bookingJson));
  }

  // -------- Notifications --------
  Future<List<ProviderNotificationApiModel>> getNotifications() async {
    final res = await _dio.get(ApiEndpoints.notifications);
    final items = (res.data?['items'] as List? ?? []).cast<dynamic>();

    return items
        .map((e) => ProviderNotificationApiModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> markNotificationRead(String id) async {
    await _dio.patch(ApiEndpoints.notificationRead(id), data: {});
  }

  Future<void> createRating({
  required String bookingId,
  required int stars,
  String? comment,
  }) async {
  final payload = {
    "bookingId": bookingId,
    "stars": stars,
    if (comment != null && comment.trim().isNotEmpty) "comment": comment.trim(),
  };

  await _dio.post(ApiEndpoints.ratings, data: payload);
  }

  // -------- Avatar --------
  Future<ProviderMeApiModel> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      "avatar": await MultipartFile.fromFile(filePath),
    });

    final res = await _dio.post(ApiEndpoints.uploadAvatar, data: formData);
    final data = (res.data is Map) ? Map<String, dynamic>.from(res.data) : <String, dynamic>{};

    final userJson = data['user'];
    if (userJson is! Map) throw Exception("Invalid avatar upload response");
    return ProviderMeApiModel.fromJson(Map<String, dynamic>.from(userJson));
  }
}