class RateLimiter {
  final int maxRequests;
  final Duration duration;
  int _requestCount = 0;
  DateTime _startTime = DateTime.now();

  RateLimiter(this.maxRequests, this.duration);

  bool allowRequest() {
    if (_requestCount >= maxRequests && DateTime.now().difference(_startTime) < duration) {
      return false;
    }
    if (DateTime.now().difference(_startTime) >= duration) {
      _startTime = DateTime.now();
      _requestCount = 0;
    }
    _requestCount++;
    return true;
  }
}
