import 'package:flutter_test/flutter_test.dart';
import 'package:alaz/alaz.dart';
import 'package:alaz/src/options.dart';
import 'package:alaz/src/request.dart';
import 'package:alaz/src/response.dart';

class TestInterceptor extends Interceptor {
  final void Function(AlazRequest)? onRequestCallback;
  final void Function(AlazResponse)? onResponseCallback;
  final void Function(dynamic)? onErrorCallback;

  TestInterceptor({
    this.onRequestCallback,
    this.onResponseCallback,
    this.onErrorCallback,
  });

  @override
  Future<void> onRequest(AlazRequest request) async {
    if (onRequestCallback != null) {
      onRequestCallback!(request);
    }
  }

  @override
  Future<void> onResponse(AlazResponse response) async {
    if (onResponseCallback != null) {
      onResponseCallback!(response);
    }
  }

  @override
  Future<void> onError(dynamic error) async {
    if (onErrorCallback != null) {
      onErrorCallback!(error);
    }
  }
}

void main() {
  group('Alaz HTTP Requests', () {
    late Alaz alaz;

    setUp(() {
      alaz = Alaz();
    });

    test('GET request test', () async {
      final response = await alaz.get('https://jsonplaceholder.typicode.com/posts/1');
      expect(response.statusCode, 200);
      expect(response.data, isNotNull);
      expect(response.data['id'], 1);
    });

    test('POST request test with JSON data', () async {
      final response = await alaz.post(
        'https://jsonplaceholder.typicode.com/posts',
        data: {'title': 'foo', 'body': 'bar', 'userId': 1},
      );
      expect(response.statusCode, 201);
      expect(response.data['title'], 'foo');
    });

    test('Timeout setting', () async {
      alaz = Alaz(
        options: AlazOptions(connectTimeout: 1),
      );
      expect(() async {
        await alaz.get('https://jsonplaceholder.typicode.com/posts/1');
      }, throwsA(isA<TimeoutError>()));
    });

    test('Retry mechanism', () async {
      int retryAttempts = 0;
      
      alaz.addInterceptor(TestInterceptor(
        onRequestCallback: (AlazRequest request) async {
          retryAttempts++;
        },
      ));

      try {
        await alaz.get('https://invalid-url', cancelToken: null);
      } catch (_) {}
      expect(retryAttempts, greaterThan(1));
    });

    test('Request cancellation', () async {
      final cancelToken = CancelToken();
      alaz.get('https://jsonplaceholder.typicode.com/posts/1', cancelToken: cancelToken);
      cancelToken.cancel();
      expect(() async {
        await alaz.get('https://jsonplaceholder.typicode.com/posts/1', cancelToken: cancelToken);
      }, throwsA(isA<AlazError>()));
    });
  });
}
