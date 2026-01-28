import 'package:sajilo_sewa/core/api/api_endpoints.dart';

class UrlUtils {
  UrlUtils._();

 
  static String normalizeMediaUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.contains('http://localhost:')) {
      return url.replaceFirst('http://localhost:${5000}', ApiEndpoints.serverUrl);
    }
    if (url.contains('https://localhost:')) {
      return url.replaceFirst('https://localhost:${5000}', ApiEndpoints.serverUrl);
    }
    return url;
  }
}
