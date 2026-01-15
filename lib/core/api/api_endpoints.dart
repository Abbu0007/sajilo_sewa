class ApiEndpoints {
  // Android Emulator -> http://10.0.2.2:5000
  // Real phone -> http://YOUR_PC_IP:5000
  static const String baseUrl = 'http://10.0.2.2:5000';

  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
}
