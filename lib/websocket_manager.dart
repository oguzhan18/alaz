import 'dart:io';

class WebSocketManager {
  late WebSocket _socket;

  Future<void> connect(String url) async {
    _socket = await WebSocket.connect(url);
  }

  void sendMessage(String message) {
    _socket.add(message);
  }

  Stream<dynamic> get onMessage => _socket.asBroadcastStream();
}
