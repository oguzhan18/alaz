class AlazOptions {
  int? connectTimeout;
  int? receiveTimeout;
  Map<String, String> globalHeaders;
  String? proxy;
  bool useStream;

  AlazOptions({
    this.connectTimeout = 5000,
    this.receiveTimeout = 3000,
    this.globalHeaders = const {},
    this.proxy,
    this.useStream = false,
  });

  AlazOptions copyWith({
    int? connectTimeout,
    int? receiveTimeout,
    Map<String, String>? globalHeaders,
    String? proxy,
    bool? useStream,
  }) {
    return AlazOptions(
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      globalHeaders: globalHeaders ?? this.globalHeaders,
      proxy: proxy ?? this.proxy,
      useStream: useStream ?? this.useStream,
    );
  }

  Map<String, String> get headers => globalHeaders;
}

class Options {
  final AlazOptions? _options;

  Options({AlazOptions? options}) : _options = options;

  AlazOptions? toAlazOptions() => _options;
}

class CancelToken {
  bool _isCancelled = false;

  void cancel() {
    _isCancelled = true;
  }

  bool get isCancelled => _isCancelled;
}
