class AlazError implements Exception {
  final String message;

  AlazError(this.message);

  @override
  String toString() => 'AlazError: $message';
}
class TimeoutError extends AlazError {
  TimeoutError(String message) : super(message);
}

class NetworkError extends AlazError {
  NetworkError(String message) : super(message);
}

class ServerError extends AlazError {
  ServerError(String message) : super(message);
}
