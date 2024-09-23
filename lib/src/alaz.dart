import 'dart:async';
import 'dart:convert';
import 'package:alaz/alaz.dart';
import 'package:alaz/cache/cache_manager.dart';
import 'package:http/http.dart' as http;
import 'options.dart';
import 'request.dart';
import 'response.dart';
import 'errors/alaz_error.dart';
import 'interceptors/interceptor_wrapper.dart';
import 'form_data.dart';

class Alaz {
  final AlazOptions options;
  final List<Interceptor> interceptors = [];
  final CacheManager cacheManager = CacheManager();
  final InterceptorWrapper interceptorWrapper;

  Alaz({AlazOptions? options})
      : options = options ?? AlazOptions(),
        interceptorWrapper = InterceptorWrapper();

  void addInterceptor(Interceptor interceptor) {
    interceptors.add(interceptor);
  }

  Future<AlazResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    int retryCount = 3,
    bool useCache = false,
    CancelToken? cancelToken,
  }) async {
    return _sendRequest(
      'GET',
      path,
      queryParameters: queryParameters,
      options: options,
      retryCount: retryCount,
      useCache: useCache,
      cancelToken: cancelToken,
    );
  }

  Future<AlazResponse> post(
    String path, {
    dynamic data,
    Options? options,
    int retryCount = 3,
    bool useCache = false,
    CancelToken? cancelToken,
  }) async {
    return _sendRequest(
      'POST',
      path,
      data: data,
      options: options,
      retryCount: retryCount,
      useCache: useCache,
      cancelToken: cancelToken,
    );
  }

  Future<AlazResponse> _sendRequest(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    int retryCount = 3,
    bool useCache = false,
    CancelToken? cancelToken,
  }) async {
    final requestOptions = options?.toAlazOptions() ?? this.options;
    final request = AlazRequest(
      method: method,
      path: path,
      queryParameters: queryParameters,
      data: data,
      options: requestOptions,
    );

    if (cancelToken?.isCancelled ?? false) {
      throw AlazError('Request cancelled');
    }

    int attempt = 0;
    while (attempt < retryCount) {
      try {
        await interceptorWrapper.onRequest(request, interceptors);
        http.Response httpResponse;
        final uri = Uri.parse(request.fullUrl);

        switch (method) {
          case 'GET':
            httpResponse = await http.get(uri, headers: request.headers);
            break;
          case 'POST':
            if (data is AlazFormData) {
              httpResponse = await http.post(uri, headers: request.headers, body: data.toMap());
            } else {
              httpResponse = await http.post(uri, headers: request.headers, body: jsonEncode(request.data));
            }
            break;
          default:
            throw AlazError('HTTP method $method not implemented');
        }

        final alazResponse = AlazResponse.fromHttpResponse(httpResponse);
        await interceptorWrapper.onResponse(alazResponse, interceptors);

        return alazResponse;
      } catch (e) {
        attempt++;
        if (attempt >= retryCount) {
          throw AlazError('Failed after $retryCount attempts: $e');
        }
        await Future.delayed(Duration(seconds: 2));
      }
    }

    throw AlazError('Max retry limit reached');
  }
}
