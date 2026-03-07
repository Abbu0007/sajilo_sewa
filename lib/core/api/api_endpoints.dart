import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = true;
  static const String _ipAddress = '192.168.137.1';
  static const int _port = 5000;

  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get serverUrl => 'http://$_host:$_port';
  static String get baseUrl => serverUrl;
  static String get mediaServerUrl => serverUrl;

  // Auth 
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String verifyEmail = '/api/auth/verify-email';
  static const String resendVerification = '/api/auth/resend-verification';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';

  // Profile 
  static const String me = '/api/users/me';
  static const String updateMe = '/api/users/me';
  static const String uploadAvatar = '/api/users/me/avatar';
  static const String clientMeProfile = "/api/clients/me/profile";

  // Services
  static const String services = "/api/services";

  // Providers (Client/Public) 
  static String providersByService(String slug) => "/api/providers/by-service/$slug";
  static String topRatedProviders({int limit = 8}) => "/api/providers/top-rated?limit=$limit";

  // Favourites (Client)
  static const String favourites = "/api/favourites";
  static String favouriteToggle(String providerId) => "/api/favourites/$providerId";

  // Bookings (Client) 
  static const String createBooking = "/api/bookings";
  static String myBookings({String status = "all"}) => "/api/bookings/mine?status=$status";

  // Notifications  
  static const String notifications = "/api/notifications";
  static String notificationRead(String id) => "/api/notifications/$id/read";
  static const String ratings = "/api/ratings";

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  //Provider
  // Provider Bookings (Provider) 
static String providerBookingsMine({String status = "all"}) =>
    "/api/provider/bookings/mine?status=$status";

static String providerBookingAccept(String bookingId) =>
    "/api/provider/bookings/$bookingId/accept";

static String providerBookingReject(String bookingId) =>
    "/api/provider/bookings/$bookingId/reject";

static String providerBookingUpdateStatus(String bookingId) =>
    "/api/provider/bookings/$bookingId/status";

  static const String providerMeProfile = "/api/providers/me/profile";
}