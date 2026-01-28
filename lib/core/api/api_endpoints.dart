import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  /// Set true when testing on real phone (same Wi-Fi as your PC)
  static const bool isPhysicalDevice = false;

  /// Replace with YOUR PC IP when on real phone
  static const String _ipAddress = '192.168.1.10';

  /// Your backend port (from Postman)
  static const int _port = 5000;

  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get serverUrl => 'http://$_host:$_port';

  /// You are using /api/... routes, so baseUrl is serverUrl
  static String get baseUrl => serverUrl;

  /// Uploads/media base (same server)
  static String get mediaServerUrl => serverUrl;

  // --- Auth ---
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';

  // --- Profile ---
  static const String me = '/api/users/me';
  static const String updateMe = '/api/users/me';
  static const String uploadAvatar = '/api/users/me/avatar';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
