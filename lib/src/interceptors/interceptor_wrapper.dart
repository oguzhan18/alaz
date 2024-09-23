import '../request.dart';
import '../response.dart';
import 'interceptor.dart';

class InterceptorWrapper {
  Future<void> onRequest(AlazRequest request, List<Interceptor> interceptors) async {
    for (var interceptor in interceptors) {
      try {
        await interceptor.onRequest(request);
      } catch (e) {
        print('Interceptor onRequest error: $e');
        rethrow;
      }
    }
  }

  Future<void> onResponse(AlazResponse response, List<Interceptor> interceptors) async {
    for (var interceptor in interceptors) {
      try {
        await interceptor.onResponse(response);
      } catch (e) {
        print('Interceptor onResponse error: $e');
        rethrow;
      }
    }
  }

  Future<void> onError(dynamic error, List<Interceptor> interceptors) async {
    for (var interceptor in interceptors) {
      try {
        await interceptor.onError(error);
      } catch (e) {
        print('Interceptor onError error: $e');
        rethrow;
      }
    }
  }
}
