class ChatMessage {
  final int id;
  final int senderId;
  final String senderUsername;
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderUsername,
    required this.content,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['sender_id'] ?? json['sender'],
      senderUsername: json['sender_username'] ?? '',
      content: json['content'] ?? json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? json['created_at']),
    );
  }
}

class Conversation {
  final int id;
  final int itemId;
  final String itemTitle;
  final int otherUserId;
  final String otherUsername;
  final ChatMessage? lastMessage;

  Conversation({
    required this.id,
    required this.itemId,
    required this.itemTitle,
    required this.otherUserId,
    required this.otherUsername,
    this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      itemId: json['item'],
      itemTitle: json['item_title'] ?? '',
      otherUserId: json['other_user_id'] ?? 0,
      otherUsername: json['other_username'] ?? '',
      lastMessage: json['last_message'] != null 
          ? ChatMessage.fromJson(json['last_message']) 
          : null,
    );
  }
}
