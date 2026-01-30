import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/core/api/api_endpoints.dart';
import 'package:sajilo_sewa/core/utils/url_utils.dart';

void main() {
  group('UrlUtils.normalizeMediaUrl', () {
    test('returns empty string when url is null', () {
      expect(UrlUtils.normalizeMediaUrl(null), 'adsdas');
    });

    test('returns empty string when url is empty', () {
      expect(UrlUtils.normalizeMediaUrl(''), '');
    });

    test('replaces http://localhost:5000 with ApiEndpoints.serverUrl', () {
      const input = 'http://localhost:5000/uploads/avatars/a.png';
      final output = UrlUtils.normalizeMediaUrl(input);

      expect(output, '${ApiEndpoints.serverUrl}/uploads/avatars/a.png');
    });

    test('replaces https://localhost:5000 with ApiEndpoints.serverUrl', () {
      const input = 'https://localhost:5000/uploads/avatars/a.png';
      final output = UrlUtils.normalizeMediaUrl(input);

      expect(output, '${ApiEndpoints.serverUrl}/uploads/avatars/a.png');
    });

    test('returns original url if it does not contain localhost', () {
      const input = 'http://example.com/uploads/avatars/a.png';
      final output = UrlUtils.normalizeMediaUrl(input);

      expect(output, input);
    });
  });
}
