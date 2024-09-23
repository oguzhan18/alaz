import 'package:alaz/alaz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alaz/src/interceptors/interceptor_wrapper.dart';
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
  group('InterceptorWrapper Tests', () {
    late InterceptorWrapper interceptorWrapper;
    late List<Interceptor> interceptors;

    setUp(() {
      interceptorWrapper = InterceptorWrapper();
      interceptors = [];
    });

    test('onRequest should call all interceptors', () async {
      bool firstInterceptorCalled = false;
      bool secondInterceptorCalled = false;

      interceptors.add(TestInterceptor(
        onRequestCallback: (AlazRequest request) async {
          firstInterceptorCalled = true;
        },
      ));

      interceptors.add(TestInterceptor(
        onRequestCallback: (AlazRequest request) async {
          secondInterceptorCalled = true;
        },
      ));

      final request = AlazRequest(
        method: 'GET',
        path: 'https://jsonplaceholder.typicode.com/posts/1',
        options: AlazOptions(),
      );
      await interceptorWrapper.onRequest(request, interceptors);

      expect(firstInterceptorCalled, isTrue);
      expect(secondInterceptorCalled, isTrue);
    });

    test('onResponse should call all interceptors', () async {
      bool responseInterceptorCalled = false;

      interceptors.add(TestInterceptor(
        onResponseCallback: (AlazResponse response) async {
          responseInterceptorCalled = true;
        },
      ));

      final response = AlazResponse(statusCode: 200, headers: {}, data: {});
      await interceptorWrapper.onResponse(response, interceptors);

      expect(responseInterceptorCalled, isTrue);
    });

    test('onError should call all interceptors', () async {
      bool errorInterceptorCalled = false;

      interceptors.add(TestInterceptor(
        onErrorCallback: (error) async {
          errorInterceptorCalled = true;
        },
      ));

      await interceptorWrapper.onError(Exception('Test error'), interceptors);
      expect(errorInterceptorCalled, isTrue);
    });
  });
}
