import 'options.dart';

class AlazRequest {
  final String method;
  final String path;
  final Map<String, dynamic>? queryParameters;
  final dynamic data;
  final AlazOptions options;

  AlazRequest({
    required this.method,
    required this.path,
    this.queryParameters,
    this.data,
    required this.options,
  });

  String get fullUrl {
    if (queryParameters != null && queryParameters!.isNotEmpty) {
      final query = queryParameters!.entries.map((e) => '${e.key}=${e.value}').join('&');
      return '$path?$query';
    }
    return path;
  }

  Map<String, String> get headers => options.headers;
}
