# Alaz

[![pub package](https://img.shields.io/pub/v/alaz.svg)](https://pub.dev/packages/alaz)

Alaz is a powerful and customizable HTTP client for Dart and Flutter. It includes features such as retry mechanism, interceptors, request cancellation, caching, and more.

## Features

- **HTTP Requests**: Supports GET, POST, and other HTTP methods.
- **Retry Mechanism**: Automatically retries failed requests.
- **Interceptors**: Add interceptors to modify requests, responses, or handle errors.
- **Request Cancellation**: Easily cancel ongoing HTTP requests.
- **Caching**: Cache HTTP responses to improve performance.
- **Timeout Control**: Customize connection and response timeouts.
- **Proxy Support**: Send requests through a proxy server.
- **Chained Requests**: Chain multiple HTTP requests.

## Installation

Add `alaz` to your `pubspec.yaml` file:

```yaml
dependencies:
  alaz: ^1.0.0
```
## Then run:
```bash
flutter pub get
```
## Getting Started
Here’s how to use Alaz in your project:
### Basic Usage
```dart
import 'package:alaz/alaz.dart';

void main() async {
  final alaz = Alaz();

  // Simple GET request
  final response = await alaz.get('https://jsonplaceholder.typicode.com/posts/1');
  print(response.data);

  // POST request with data
  final postResponse = await alaz.post('https://jsonplaceholder.typicode.com/posts',
    data: {'title': 'foo', 'body': 'bar', 'userId': 1});
  print(postResponse.data);
}

```
## Retry Mechanism:
Alaz automatically retries failed requests based on the configured `retryCount`.
```dart
final alaz = Alaz(
  options: AlazOptions(retryCount: 3),
);

try {
  final response = await alaz.get('https://invalid-url');
} catch (e) {
  print('Request failed after 3 retries.');
}

```
### Interceptors
You can add interceptors to modify requests, responses, or handle errors.

```dart
final alaz = Alaz();
alaz.addInterceptor(TestInterceptor(
  onRequestCallback: (AlazRequest request) async {
    print('Requesting: ${request.path}');
  },
  onResponseCallback: (AlazResponse response) async {
    print('Response received: ${response.statusCode}');
  },
  onErrorCallback: (error) async {
    print('Error occurred: $error');
  },
));

```
### Request Cancellation
You can cancel ongoing requests using `CancelToken`.
```dart
final alaz = Alaz();
final cancelToken = CancelToken();

alaz.get('https://jsonplaceholder.typicode.com/posts/1', cancelToken: cancelToken);

cancelToken.cancel();

```
### Timeout Configuration
You can set custom timeouts for requests.

```dart
final alaz = Alaz(
  options: AlazOptions(connectTimeout: 5000, receiveTimeout: 3000),
);

try {
  final response = await alaz.get('https://jsonplaceholder.typicode.com/posts/1');
} catch (e) {
  print('Request timed out.');
}

```

### Proxy Support
Alaz can send requests through a proxy.
```dart
final alaz = Alaz(
  options: AlazOptions(proxy: 'http://proxy-server.com:8080'),
);

final response = await alaz.get('https://jsonplaceholder.typicode.com/posts/1');

```
### Chained Requests
You can chain multiple requests together.
```dart
final alaz = Alaz();

final firstResponse = await alaz.get('https://jsonplaceholder.typicode.com/posts/1');
final secondResponse = await alaz.get('https://jsonplaceholder.typicode.com/posts/2');

final chainedResponse = await alaz.chainRequests(firstResponse, secondResponse);
print(chainedResponse.data);

```
### Testing
To run the tests, simply use the `flutter test` command:
```bash
flutter test
```

