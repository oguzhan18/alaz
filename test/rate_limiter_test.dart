import 'package:flutter_test/flutter_test.dart';
import 'package:alaz/src/rate_limiter.dart';

void main() {
  group('RateLimiter Tests', () {
    test('Allow requests within limit', () {
      final rateLimiter = RateLimiter(2, Duration(seconds: 10));

      expect(rateLimiter.allowRequest(), isTrue);
      expect(rateLimiter.allowRequest(), isTrue);
    });

    test('Deny requests over limit', () {
      final rateLimiter = RateLimiter(2, Duration(seconds: 10));

      rateLimiter.allowRequest();
      rateLimiter.allowRequest();
      expect(rateLimiter.allowRequest(), isFalse);
    });

    test('Reset after duration', () async {
      final rateLimiter = RateLimiter(2, Duration(seconds: 1));

      rateLimiter.allowRequest();
      rateLimiter.allowRequest();

      await Future.delayed(Duration(seconds: 1));
      expect(rateLimiter.allowRequest(), isTrue);
    });
  });
}
