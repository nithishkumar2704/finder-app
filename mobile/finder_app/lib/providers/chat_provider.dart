import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/chat.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  static const String baseUrl = 'http://10.0.2.2:8000/api/chat';
  
  List<Conversation> _conversations = [];
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  ChatService? _activeChatService;

  List<Conversation> get conversations => _conversations;
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> fetchConversations() async {
    _isLoading = true;
    notifyListeners();

    final token = await _storage.read(key: 'accessToken');
    final response = await http.get(
      Uri.parse('$baseUrl/conversations/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      _conversations = data.map((json) => Conversation.fromJson(json)).toList();
    }
    
    _isLoading = false;
    notifyListeners();
  }

  void connectToChat(int conversationId) async {
    final token = await _storage.read(key: 'accessToken');
    if (token == null) return;

    _messages = []; // Clear old messages
    _activeChatService?.dispose();
    
    _activeChatService = ChatService(conversationId: conversationId, token: token);
    _activeChatService!.connect();
    
    _activeChatService!.messages.listen((data) {
      final decodedData = jsonDecode(data);
      if (decodedData['type'] == 'chat_message') {
        _messages.add(ChatMessage.fromJson(decodedData['message']));
        notifyListeners();
      }
    });
  }

  void sendMessage(String text) {
    _activeChatService?.sendMessage(text);
  }

  @override
  void dispose() {
    _activeChatService?.dispose();
    super.dispose();
  }
}
