import 'package:http/http.dart' as http;

class AlazResponse {
  final int statusCode;
  final Map<String, String> headers;
  final dynamic data;
  final Stream<List<int>>? stream;

  AlazResponse({
    required this.statusCode,
    required this.headers,
    required this.data,
    this.stream,
  });

  factory AlazResponse.fromHttpResponse(http.Response response) {
    return AlazResponse(
      statusCode: response.statusCode,
      headers: response.headers,
      data: response.body,
    );
  }

  factory AlazResponse.fromStream(http.StreamedResponse response) {
    return AlazResponse(
      statusCode: response.statusCode,
      headers: response.headers,
      stream: response.stream,
      data: null,
    );
  }
}

