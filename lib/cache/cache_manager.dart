import 'package:alaz/alaz.dart';

class CacheManager {
  final Map<String, AlazResponse> _cache = {};

  void storeResponse(String key, AlazResponse response) {
    _cache[key] = response;
  }

  AlazResponse? getResponse(String key) {
    return _cache[key];
  }

  void clearCache() {
    _cache.clear();
  }
}
