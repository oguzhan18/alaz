import 'package:flutter_test/flutter_test.dart';
import 'package:alaz/src/options.dart';

void main() {
  group('AlazOptions Tests', () {
    test('Default options', () {
      final options = AlazOptions();
      expect(options.connectTimeout, 5000);
      expect(options.receiveTimeout, 3000);
      expect(options.globalHeaders, isEmpty);
    });

    test('Custom options', () {
      final options = AlazOptions(
        connectTimeout: 10000,
        receiveTimeout: 5000,
        globalHeaders: {'Authorization': 'Bearer token'},
      );
      expect(options.connectTimeout, 10000);
      expect(options.receiveTimeout, 5000);
      expect(options.globalHeaders['Authorization'], 'Bearer token');
    });

    test('Options copyWith', () {
      final options = AlazOptions().copyWith(connectTimeout: 8000);
      expect(options.connectTimeout, 8000);
    });
  });
}
