import 'package:alaz/cache/cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alaz/src/response.dart';

void main() {
  group('CacheManager Tests', () {
    late CacheManager cacheManager;

    setUp(() {
      cacheManager = CacheManager();
    });

    test('Store and retrieve response from cache', () {
      final response = AlazResponse(statusCode: 200, headers: {}, data: {});
      cacheManager.storeResponse('https://example.com', response);

      final cachedResponse = cacheManager.getResponse('https://example.com');
      expect(cachedResponse, isNotNull);
      expect(cachedResponse!.statusCode, 200);
    });

    test('Cache should return null if key does not exist', () {
      final cachedResponse = cacheManager.getResponse('https://not-in-cache.com');
      expect(cachedResponse, isNull);
    });

    test('Clear cache should remove all entries', () {
      final response = AlazResponse(statusCode: 200, headers: {}, data: {});
      cacheManager.storeResponse('https://example.com', response);

      cacheManager.clearCache();
      final cachedResponse = cacheManager.getResponse('https://example.com');
      expect(cachedResponse, isNull);
    });
  });
}
