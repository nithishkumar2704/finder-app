import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class ChatService {
  final int conversationId;
  final String token;
  late WebSocketChannel _channel;

  ChatService({required this.conversationId, required this.token});

  void connect() {
    // 10.0.2.2 is localhost for Android Emulator
    final wsUrl = 'ws://10.0.2.2:8000/ws/chat/$conversationId/?token=$token';
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
  }

  Stream get messages => _channel.stream;

  void sendMessage(String text) {
    _channel.sink.add(jsonEncode({
      'message': text,
    }));
  }

  void dispose() {
    _channel.sink.close(status.goingAway);
  }
}
