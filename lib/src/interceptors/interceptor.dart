import '../request.dart';
import '../response.dart';

abstract class Interceptor {
  Future<void> onRequest(AlazRequest request);
  Future<void> onResponse(AlazResponse response);
  Future<void> onError(dynamic error);
}
