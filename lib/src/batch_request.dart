import 'package:alaz/alaz.dart';

class BatchRequest {
  final List<Future<AlazResponse>> requests = [];

  void addRequest(Future<AlazResponse> request) {
    requests.add(request);
  }

  Future<List<AlazResponse>> executeAll() async {
    return await Future.wait(requests);
  }
}
